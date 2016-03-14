class ApplicationServiceConnectorType < ActiveRecord::Base

  attr_accessor :create_type,
                :orphan_service,
                :active_service

  belongs_to :application_service_connector

  validate :connect_type_form_valid?

  def connect_type_form_valid?
    case create_type.to_sym
    when :active
       errors.add(:active_service, "can't be blank") if active_service.blank?
    when :orphan
       errors.add(:orphan_service, "can't be blank") if orphan_service.blank?
    end
  end

  def existing_service_params_json
    case create_type.to_sym
    when :active
      active_service
    when :orphan
      orphan_service
    else
      {}.to_json
    end
  end

  def existing_service_params
    JSON.parse(existing_service_params_json).deep_symbolize_keys
  end



end
