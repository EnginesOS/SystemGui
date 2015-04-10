class BackupTask < ActiveRecord::Base

  has_many :variables, as: :variable_consumer, dependent: :destroy
  belongs_to :backup_tasks_handler

  accepts_nested_attributes_for :variables

  attr_accessor(
    :type_path,
    :publisher_namespace,
    :service_handle)

  def load_variables
    backup_service_definition = EnginesBackupTask.backup_service_definition type_path, publisher_namespace
    variables_attributes = backup_service_definition[:consumer_params].values
    self.variables.build(variables_attributes)
  end


  # def initialize params
# #    type_path: @type_path,
# #      publisher_namespace: @publisher_namespace,
# #      service_handle:
# 
# p :backup_params
# p params
# 
# # {"parent_engine"=>"phpmyadmin", "publisher_namespace"=>"EnginesSystem", "service_handle"=>"phpmyadmin", "type_path"=>"database/sql/mysql"}
# 
# 
#     
    # backup_service_definition = EnginesBackupTask.backup_service_definition params
    # backup_service_definition[:setup_params][:name][:value] = default_backup_name
# 
# p :backup_service_definition
# p backup_service_definition
# 
# # {:type_path=>"backup", :publisher_namespace=>"EnginesSystem",
# # :setup_params=>{:name=>{
# 
# # :regex_invalid_message
# # :name
# # :label
# # :regex_validator
# # :tooltip
# # :field_type
# # :hint
# # :placeholder
# # :mandatory
# # :value
# # :comment
# # }, :dest_proto=>{:regex_invalid_message=>"wrong go back and try again", :name=>"dest_proto", :label=>"Backup Destination Type", :regex_validator=>".*", :tooltip=>" ", :field_type=>"select", :hint=>"", :placeholder=>"a label ", :mandatory=>true, :value=>" ", :comment=>" ", :select_collection=>["ftp", "local", "smbfs", "nfs", "s3"]}, :dest_folder=>{:regex_invalid_message=>"wrong go back and try again", :name=>"dest_folder", :label=>"destination folder", :regex_validator=>".*", :tooltip=>" ", :field_type=>"text_field", :hint=>"", :placeholder=>" ", :mandatory=>true, :value=>" ", :comment=>" "}, :dest_address=>{:regex_invalid_message=>"wrong go back and try again", :name=>"dest_address", :label=>"destination", :regex_validator=>".*", :tooltip=>" ", :field_type=>"text_field", :hint=>"", :placeholder=>" ", :mandatory=>true, :value=>" ", :comment=>" "}, :dest_user=>{:regex_invalid_message=>"wrong go back and try again", :name=>"dest_user", :label=>"user_name", :regex_validator=>".*", :tooltip=>" ", :field_type=>"text_field", :hint=>"", :placeholder=>" ", :mandatory=>true, :value=>" ", :comment=>" "}, :dest_pass=>{:regex_invalid_message=>"wrong go back and try again", :name=>"dest_pass", :label=>"password", :regex_validator=>".*", :tooltip=>" ", :field_type=>"password", :hint=>"", :placeholder=>" ", :mandatory=>true, :value=>" ", :comment=>" "}}}
# 
    # # @source_name = params[:source_name]
    # @type_path = backup_service_definition[:type_path]
    # @publisher_namespace = backup_service_definition[:publisher_namespace]
    # @service_handle = backup_service_definition[:service_handle]
    # @parent_engine = backup_service_definition[:parent_engine]
    # @variables = backup_service_definition[:setup_params].values
  # end

  # def backup_type_in_words
    # case backup_type.to_s
    # when 'fs'
      # 'files'
    # when 'db'
      # 'database'
    # else
      # 'unknown backup type'
    # end
  # end

  def save
    EnginesAttachedService.attach_service engines_backup_task_params
  end

private

  def engines_backup_task_params
    {
      type_path: type_path,
      publisher_namespace: publisher_namespace,
      parent_service_handle: service_handle,
      variables: engines_backup_task_variables_params
    }
  end

  def engines_backup_task_variables_params
    variables_params = variables.map { |variable| { variable.name.to_sym => variable.value } }.inject(:merge)
    variables_params[:parent_engine] = backup_tasks_handler.software.engine_name
    variables_params
  end


  # def default_backup_name
    # ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join
  # end
  
end