class ApplicationServiceDataImport < ActiveRecord::Base

  include Engines::Api

  after_initialize :set_defaults

  attr_accessor :application_name, :connection_params,
                :data_file_file_name, :data_file_content_type,
                :data_file_file_size, :data_file_updated_at,
                :import_method, :engines_api_error

  has_attached_file :data_file

  validates_attachment_content_type :data_file, :content_type => /\Aapplication\/.*\Z/
  validates_attachment_presence :data_file

  def save
    valid? && persist!
  end

private

  def persist!
    result = engines_api.import_service(persist_params)
    if result.was_success
      true
    else
      @engines_api_error = result.result_mesg.present? ? result.result_mesg : 'Engines Error. No message given.'
      false
    end
  end

  def set_defaults
    @import_method ||= :replace
  end

  def file_content
    open(self.data_file.queued_for_write[:original].path).read
  end

  def persist_params
    {
      service_connection: JSON.parse(connection_params).deep_symbolize_keys,
      data: file_content,
      import_method: import_method
    }
  end

end
