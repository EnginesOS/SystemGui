class ApplicationService < ActiveRecord::Base

  attr_accessor :connection_params,
                :service_action,
                :engines_api_error

  belongs_to :application
  has_many :variables, as: :variable_consumer, dependent: :destroy
  # has_many :application_subservices, dependent: :destroy

  accepts_nested_attributes_for :variables

  def existing_connection
    @existing_connection ||= ApplicationServiceConnection.new(self)
  end

  def edit_connection_params
    {
      application_name: application.container_name,
      application_service: {
        connection_params: connection_params
      }
    }
  end

  def new_record?
    false
  end

  def update
    valid? && existing_connection.update
  end

  def destroy
    existing_connection.destroy
  end

  def perform_action
    existing_connection.perform_action
  end

end
