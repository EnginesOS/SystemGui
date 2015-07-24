class SystemSecurityKey < ActiveRecord::Base

  has_attached_file :public_key

  attr_accessor :key

end

