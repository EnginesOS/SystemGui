class RepositoryUrlInstallation

  include ActiveModel::Model

  attr_accessor :repository_url
  
  validates :repository_url, presence: true

  def new_record?
    true
  end

end