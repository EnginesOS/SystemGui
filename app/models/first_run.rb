class FirstRun

  include ActiveModel::Model

  attr_accessor(
    :admin_password,
    :ssh_password,
    :mysql_password,
    :psql_password,
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

end