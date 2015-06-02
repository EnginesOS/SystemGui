class NetworkProperties < ActiveRecord::Base

  include Engines::Api

  attr_accessor :host_name, :domain_name, :http_protocol, :engines_api_error

  # after_initialize :load

  belongs_to :application

  name_regex = /^[A-Za-z0-9]*$/
  validates :host_name, {format: { with:name_regex, multiline: true, 
      message: "is invalid (please use character a-z and 0-9)" },
    length: {minimum: 2, maximum: 50}}
  validate :domain_name_present
  # validate :fqdn_is_unique_on_update?, on: :update
  # validate :fqdn_is_unique?, on: :create

  def domain_name_present
    if domain_name.present?
      true
    else
      errors.add(:domain_name, ["Domain name", "can't be blank"])
    end
  end

  def application_name
    application.container_name
  end

  def load
    assign_attributes(
      host_name: application.host_name,
      domain_name: application.domain_name,
      http_protocol: application.http_protocol )
  end

  # def update(network_properties_params)
    # assign_attributes(network_properties_params) && update_network_properties
  # end

  def update_engines
      valid? && commit_update_to_engines
  end

  def new_record?
    false
  end  

  def engines_update_params
    {engine_name: application.container_name, domain_name: domain_name, host_name: host_name, http_protocol: http_protocol}
  end

  def commit_update_to_engines
    result = engines_api.set_engine_network_properties(engines_update_params)
    if result.was_success
      @engines_api_error = nil
      true
    else
      @engines_api_error = (result.result_mesg.present? ? result.result_mesg : "Unable to update network properties. No result message given by engines api. #{engines_update_params}")
      false
    end
  end

end