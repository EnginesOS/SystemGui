class ImageDimensionsValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    if record.send("#{attribute}?".to_sym)
      dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
      width = options[:width]
      height = options[:height]
      record.errors[attribute] << "width must be at least #{width}px" if dimensions.width < width
      record.errors[attribute] << "height must be at least #{height}px" if dimensions.height < height
    end
  end
  
end