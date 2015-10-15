class FirstRun

  include Engines::FirstRun
  include ActiveModel::Model
  include ActiveModel::Validations
  extend Engines::Api
  include Engines::Api

  attr_accessor(
    :admin_password,
    :admin_password_confirmation,
    :console_password,
    :console_password_confirmation,
    :mysql_password,
    :mysql_password_confirmation,
    :default_domain,
    :default_domain_config,
    :ssl_country,
    :ssl_state,
    :ssl_city,
    :ssl_organisation_name,
    :ssl_person_name)

  validate :password_confirmation_validation
  validate :password_present_and_length_validation
  validate :admin_password_different_to_console_password_validation
  validate :default_domain_is_valid
  validate :ssl_fields_valid

  def self.required?
    engines_api.first_run_required?
  end
  
  def submit
    engines_api.set_first_run_parameters submit_params
  end

  def default_domain_is_valid
    domain_name_regex = /^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+([a-zA-Z0-9]{2,5})$/
    if default_domain.blank?
      errors.add(:default_domain, ["Default domain", "can't be blank"])
    elsif !default_domain.match(domain_name_regex)
      errors.add(:default_domain, ["Default domain", "is invalid"])
    end
  end

  def ssl_fields_valid
    if ssl_person_name.blank?
      errors.add(:ssl_person_name, ["Person name", "can't be blank"])
    end
    if ssl_organisation_name.blank?
      errors.add(:ssl_organisation_name, ["Organisation name", "can't be blank"])
    end
    if ssl_city.blank?
      errors.add(:ssl_city, ["City", "can't be blank"])
    end
    if ssl_state.blank?
      errors.add(:ssl_state, ["State", "can't be blank"])
    end
    if ssl_country.blank?
      errors.add(:ssl_country, ["Country", "can't be blank"])
    end
  end

  def password_confirmation_validation
    password_types.each do |password_name|
      if send("#{password_name.downcase}_password") != send("#{password_name.downcase}_password_confirmation")
        errors.add("#{password_name.downcase}_password", ["#{password_name} passwords", "do not match"])
      end
    end
  end

  def password_present_and_length_validation
    password_types.each do |password_name|
      password_field = "#{password_name.downcase}_password"
      password_value = send(password_field)
      if password_value.blank?
        errors.add(password_field, ["#{password_name} password", "can't be blank"])
      elsif password_value.length < 6
        errors.add(password_field, ["#{password_name} password", "must be at least 6 charters long"])
      end
    end
  end

  def admin_password_different_to_console_password_validation
    if admin_password != "" && admin_password == console_password
      errors.add(:console_password, ["Console password", "must be different from Admin password"])
    end
  end
  
  def encrypt_password
    
  end

  def password_types
    ["Admin", "Console", "MySQL"]
  end
  
  def submit_params
    {
      admin_password: admin_password,
      console_password: console_password.crypt('$1$' + SecureRandom.hex(6)),
      mysql_password: mysql_password,
      default_domain: default_domain,
      default_domain_internal_only: default_domain_config == 'Private',
      default_domain_self_hosted: (default_domain_config == 'Private' || default_domain_config.include?('self-hosted DNS') ),
      ssl_person_name: ssl_person_name,
      ssl_organisation_name: ssl_organisation_name,
      ssl_city: ssl_city,
      ssl_state: ssl_state,
      ssl_country: ssl_country
    }
  end

end