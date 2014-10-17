class BackupTask
  include ActiveModel::Model

  attr_accessor :source_name
  attr_accessor :backup_type
  attr_accessor :engine_name
  attr_accessor :backup_name
  attr_accessor :protocol
  attr_accessor :address
  attr_accessor :folder
  attr_accessor :username
  attr_accessor :password

end