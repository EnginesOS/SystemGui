class Library < ActiveRecord::Base

  validates :url, presence: true
  validates :name, presence: true

  def destroy
    super if id != first
  end

  def self.all_sorted
    all.sort_by{|d| d.name}
  end

  def self.library_names
    all_sorted.map(&:name)
  end

  def softwares(find_software_params={})
    @softwares ||= ( load_library_data(softwares_url(find_software_params)) || [] )
    if @softwares.is_a? Array
      @softwares = {softwares: @softwares, total_pages: 1}
    end
    @softwares
  end

  def software_tags_list
    @software_tags_list ||= load_library_data(software_tags_url)
  end


  def softwares_url(find_software_params)
    split_url = url.split('?')
    base_url = split_url[0]
    url_params = split_url[1]
    search_string = "search=#{find_software_params[:search]}&tags=#{find_software_params[:tags]}&page=#{find_software_params[:page]}&per_page=#{find_software_params[:per_page]}&#{url_params}"
a =    "http://#{base_url}/api/v0/software?#{search_string}"
p :softwares_url
p a
a

  end

  def software_tags_url
    "http://" + url[0] + "/api/v0/software_tags?" + url[1]
  end

private

  def load_library_data(library_data_url)
    library_uri = URI(library_data_url)
    return nil if (library_uri.host.nil? || library_uri.port.nil?)
    Net::HTTP.start(library_uri.host, library_uri.port) do |http|
      request = Net::HTTP::Get.new library_uri
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
