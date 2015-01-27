class AttachedServicesHandler < ActiveRecord::Base

  # attr_accessor(
  #   :title,
  #   :service_type)

  belongs_to :software
  has_many :attached_services

  accepts_nested_attributes_for :attached_services

  # def self.save_to_api params
  #   EnginesAttachedServices.update_components(params_for_api_update).was_success
  # end

  def available_subservices
    EnginesSoftware.available_services(software.engine_name, service_type)
  end

# [:components][attached_service.name]


  def load_attached_services
    attached_services.clear
    attached_services.build(attached_services_params_from_api_data)
  end

  def available_services
    EnginesSoftware.available_services(software.engine_name) #[:services]
  end




private

  def attached_services_params_from_api_data


# Software.attached_services_handler.attached_services_from_api 
#     >>> EnginesAPI.attached_services_for 'mediawiki', 'ManagedEngine'

# [
#   'volume' => [
#     {:class_name => 'Volume', :title => 'Volume - User data', service_name: 'mediawikifs'},
#     {:class_name => 'Volume', :title => 'Volume - Site config', service_name: 'mediawikifs2'}
#   ]
  
#   {:class_name = 'Database', :title => 'Database', some_identifier: 'db#1'},
  
#   {:class_name = 'Cron', :title => 'Cron - Nighlty backup', some_identifier: 'cr#1'},
#   {:class_name = 'Cron', :title => 'Cron - Upload product data to e-comm site', some_identifier: 'cr#2'}
# ]

# EnginesAPI.get_service_definition 'volume'











# ['Volume', 'Database', 'Cron']

# Software.attached_subservices "Volume" >>> attached_services_for 'mediawikifs', 'Volume'

# [ 
#   {title: "FTP service - share of the squiggle folder", a_key_that_identifies_the_attached_service: 'ftp001' }
#   {title: "FTP service - share of the yoodi folder", a_key_that_identifies_the_attached_service: 'ftp002' }
#   {title: "MyEngines Editor - edit website", a_key_that_identifies_the_attached_service: 'ftp003' }
# ]







# {
#   'volume' => {

#   }



#   'volmanager' => [
#     {title: "FTP service - share of the squiggle folder", a_key_that_identifies_the_attached_service: 'ftp001' }
#     {title: "FTP service - share of the yoodi folder", a_key_that_identifies_the_attached_service: 'ftp002' }
#     {title: "MyEngines Editor - edit website", a_key_that_identifies_the_attached_service: 'ftp003' }
#   ],
#   'db_service_provider' => [
#     {title: "DB replication service - upload product data to e-comm server", a_key_that_identifies_the_attached_service: 'dbr001' }
#     {title: "DB replication service - backup", a_key_that_identifies_the_attached_service: 'dbr002' }
#   ],
#   'cron_provider' => [
#     {title: "Cron service - Dedup database", a_key_that_identifies_the_attached_service: 'cr001' }
#     {title: "Cron service - Nightly backup", a_key_that_identifies_the_attached_service: 'cr002' }
#   ]
#   'some_service_that_has_no_subservices_attached' => ''

# }




# {
#   "psql_server" => {

#   }
# }




x = EnginesSoftware.attached_services(software.engine_name)
p "-----------------------------------------------"
p "EnginesSoftware.attached_services(software.engine_name)"
p x

#     EnginesSoftware.attached_services(software.engine_name).map{|service_type, params| {service_type: service_type, title: params_title}}

{}

  end

  def params_for_api_update
    {
      engine_name: engine_name,
      services: {hash_key: "dunno"}
    }

    #     attached_services.map do |attached_service|
    #       {
    #         service_type: attached_service.service_type,
    #         service_provider: 'something_or_other',

    #       }
    #     end

    #   environment_variables:
    #     variables.map do |variable|
    #       {
    #         name: variable.name,
    #         value: variable.value
    #       }
    #     end


    # }

  end

end