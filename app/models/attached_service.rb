class AttachedService < ActiveRecord::Base

  attr_accessor(
    :name)

  belongs_to :attached_services_consumer

  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :attached_services, as: :attached_service_consumer, dependent: :destroy
  belongs_to :software

  accepts_nested_attributes_for :variables

  # def self.save_to_api params
  #   EnginesAttachedServices.update_components(params_for_api_update).was_success
  # end

  def self.available_services engine_name
    EnginesAttachedServices.available_services_for(software.engine_name)
  end

private

  def self.params_from_api_data(engine_name)
    EnginesSoftware.attached_services(engine_name).map{|name| {name: name}}
  end

  # def params_for_api_update
  #   {
  #     engine_name: engine_name,
  #     environment_variables:
  #       variables.map do |variable|
  #         {
  #           name: variable.name,
  #           value: variable.value
  #         }
  #       end
  #   }
  # end

end