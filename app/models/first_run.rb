class FirstRun

  include ActiveModel::Model

  attr_accessor(
    :admin_password,
    :ssh_password,
    :sql_password)

end