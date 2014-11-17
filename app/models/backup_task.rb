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

  def set_defaults params
    self.source_name = params[:source_name]
    self.backup_type = params[:backup_type]
    self.engine_name = params[:engine_name]
    self.backup_name = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join  
    self.protocol = "ftp"
    self.address = ""
    self.folder = engine_name
    self.username = ""
    self.password = ""
  end

end