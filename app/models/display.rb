class Display < ActiveRecord::Base

  attr_accessor :delete_icon

  has_attached_file :icon, dependent: :destroy

  belongs_to :software
  
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  before_validation { icon.clear if delete_icon == '1' }

end