class ApplicationServiceConnectorConfiguration < ActiveRecord::Base

  include Engines::Api

  attr_accessor :create_type,
                :existing_service

  belongs_to :application_service_connector
  has_many :variables, as: :variable_consumer, dependent: :destroy

  accepts_nested_attributes_for :variables

  def existing_service_params
    @existing_service_params ||= existing_service.present? ? JSON.parse(existing_service).symbolize_keys : {}
  end

  def service_handle
    existing_service_params[:service_handle]
  end

  def container_type
    existing_service_params[:container_type]
  end

  def service_container_name
    existing_service_params[:service_handle]
  end

  def variable_values_params
    {}.tap do |result|
      variables.each do |variable|
        value = variable.value
        if (variable.field_type.to_sym == :boolean || variable.field_type.to_sym == :checkbox)
          value = true if value == "1"
          value = false if value == "0"
        end
        result[variable.name.to_sym] = value
      end
    end    
  end

end