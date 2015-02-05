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

  validate :password_confirmation_validation
  validate :password_present_and_length_validation
  validate :admin_password_different_to_ssh_password_validation

  def password_confirmation_validation
    password_types.each do |password_name|
      if send("#{password_name.downcase}_password") != send("#{password_name.downcase}_password_confirmation")
        errors.add(:ssh_password, ["#{password_name} passwords", "do not match"])
      end
    end
  end

  def password_present_and_length_validation
    password_types.each do |password_name|
      password_value = send("#{password_name.downcase}_password")
      if password_value.blank?
        errors.add(:ssh_password, ["#{password_name} password", "can't be blank"])
      elsif password_value.length < 6
        errors.add(:ssh_password, ["#{password_name} password", "must be at least 6 charters long"])
      end
    end
  end

  def admin_password_different_to_ssh_password_validation
    if admin_password == ssh_password
      errors.add(:ssh_password, ["SSH password", "must be different from Admin password"])
    end
  end

private

  def password_types
    ["Admin", "SSH", "MySQL", "PSQL"]
  end


end