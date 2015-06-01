class NetworkProperties < ActiveRecord::Base

  include Engines::Api

  attr_accessor :host_name, :domain_name, :http_protocol

  # after_initialize :load

  belongs_to :application

  # host_name_regex = /^[A-Za-z0-9]*$/
  # validates :host_name, {format: { with: host_name_regex, multiline: true, 
      # message: "is invalid. Please use character a-z and 0-9." },
    # length: {minimum: 2, maximum: 50}}
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

  def update(network_properties_params)
    assign_attributes(network_properties_params) && save
  end

  def save
      valid? && update_network_properties
  end

  def new_record?
    false
  end  

  def update_network_properties
    engines_api.set_engine_network_properties(engine_name: application.container_name, domain_name: domain_name, host_name: host_name, http_protocol: http_protocol).was_success
  end

end