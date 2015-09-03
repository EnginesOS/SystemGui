class Gallery < ActiveRecord::Base

  validates :url, presence: true
  validates :name, presence: true

  def destroy
    super if id != first
  end
    
  def self.all_sorted
    all.sort_by{|d| d.name}
  end

  def self.gallery_names
    all_sorted.map(&:name)
  end

  def softwares(find_software_params={})
    @softwares ||= ( load_gallery_data(softwares_url(find_software_params)) || [] )
    if @softwares.is_a? Array
      @softwares = {softwares: @softwares, total_pages: 1}
    end
    @softwares
  end
  
  def software_tags_list
    @software_tags_list ||= load_gallery_data(software_tags_url)
  end

  
  def softwares_url(find_software_params)
    "http://" + url + "/api/v0/software?search=#{find_software_params[:search]}&tags=#{find_software_params[:tags]}&page=#{find_software_params[:page]}"
  end

  def software_tags_url
    "http://" + url + "/api/v0/software_tags"
  end

private

  def load_gallery_data(gallery_data_url)  
    gallery_uri = URI(gallery_data_url)
    return nil if (gallery_uri.host.nil? || gallery_uri.port.nil?)
    Net::HTTP.start(gallery_uri.host, gallery_uri.port) do |http|
      request = Net::HTTP::Get.new gallery_uri
      http.read_timeout = 10 #Default is 60 seconds
      response = http.request request   
      if response.code.to_i >= 200 && response.code.to_i < 400 
        JSON.parse(response.body)
      else
        nil
      end
    end
  rescue
    nil
  end
  
end
