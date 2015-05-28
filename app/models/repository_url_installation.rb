class RepositoryUrlInstallation

  include ActiveModel::Model

  attr_accessor :repository_url

  def new_record?
    true
  end

end