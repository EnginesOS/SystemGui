module ApplicationHelper

  def decode_json(json)
    JSON.parse(json).tap do |result|
      result.deep_symbolize_keys! if result.is_a? Hash
      result.map do |element|
        element.deep_symbolize_keys! if element.is_a? Hash
      end if result.is_a? Array
    end
  rescue
    nil
  end

end
