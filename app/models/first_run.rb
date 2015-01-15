class FirstRun

  include ActiveModel::Model
  include ActiveModel::Validations
  # include ActiveModel::Conversion
  # extend ActiveModel::Naming

  attr_accessor(
    :admin_password,
    :admin_password_confirmation,
    :ssh_password,
    :ssh_password_confirmation,
    :mysql_password,
    :mysql_password_confirmation,
    :psql_password,
    :psql_password_confirmation,
    :smarthost_hostname,
    :smarthost_username,
    :smarthost_password,
    :smarthost_authtype,
    :smarthost_port,
    :default_domain,
    :ssl_country,
    :ssl_state,
    :ssl_city,
    :ssl_organisation_name,
    :ssl_person_name)

  validates :admin_password, confirmation: true, length: { minimum: 6 }
  validates :ssh_password, confirmation: true, length: { minimum: 6 }
  validates :mysql_password, confirmation: true, length: { minimum: 6 }
  validates :psql_password, confirmation: true, length: { minimum: 6 }
  validate :admin_password_different_to_ssh_password

  def admin_password_different_to_ssh_password
    if (admin_password == ssh_password)
      errors.add(:ssh_password, "must be different from Admin password")
    end
  end

end