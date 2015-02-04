class AttachedServicesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @software = Software.find(params[:software_id])
    # @software.attached_services_handler.destroy if @software.attached_services_handler.present?
    @software.build_attached_services_handler.load_attached_services
  end

  def new
    @software = Software.find(params[:software_id])
    @attached_service = @software.build_attached_services_handler.
      attached_services.build(new_attached_service_attributes)
  end

  def create
    # render text: params

    @software = Software.find(params[:software_id])
    @attached_service = @software.build_attached_services_handler.
      attached_services.build(create_attached_service_attributes)

    if @attached_service.valid?


      api_create_params = params["attached_service"].permit!
      api_create_params["variables_attributes"].values.each do |variable|
        api_create_params[variable["name"]] = variable["value"]
      end
      api_create_params.delete("variables_attributes")

      result = EnginesAttachedService.attach_service api_create_params

      render text: (api_create_params.to_s + '<br><br>' + result.to_s).html_safe

    else


      result = []

      @attached_service.errors.full_messages.each do |msg| 
        result << msg
      end

      render :new
      # text: ('invalid' + '<br><br>' + result.to_s).html_safe

    end

  end


private

  def new_attached_service_attributes
      {
        service_type: params[:service_type],
        service_provider: params[:service_provider],
        title: params[:title],
        variables_attributes: new_attached_service_variable_attributes
      }
  end

  def create_attached_service_attributes

      params[:attached_service].permit!


      # {
      #   service_type: params[:attached_service][:service_type],
      #   service_provider: params[:attached_service][:service_provider],
      #   title: params[:attached_service][:title],
      #   variables_attributes: create_attached_service_variable_attributes
      # }
  end


  def service_detail service_type, service_provider
    EnginesSoftware.available_services(@software.engine_name).find do |service|
      service[:service_type] == service_type &&
      service[:service_provider] == service_provider
    end[:setup_params].values
  end

#   def create_attached_service_variable_attributes

#     variables_params = service_detail params[:attached_service][:service_type], params[:attached_service][:service_provider]

# # p "params[:attached_service]"
# # p params[:attached_service][:variables_attributes]"=>{"0"=>{"name"=>"volume_src", "type"=>"text_field", "value"=>""}, "1"=>{"name"=>"permissions", "type"=>"select_single", "value"=>"rw"}, "2"=>{"name"=>"local_path", "type"=>"text_field", "value"=>" "}, "3"=>{"name"=>"about_me", "type"=>"checkbox", "value"=>"0"}, "4"=>{"name"=>"country", "type"=>"country_select", "value"=>"GB"}, "5"=>{"name"=>"radio_gaga", "type"=>"select_radio"}, "6"=>{"name"=>"password_r_us", "type"=>"password_with_confirmation", "value"=>"", "value_confirmation"=>""}, "7"=>{"name"=>"checkbox_city", "type"=>"checkbox", "value"=>"1"}}}
# # "

# p "params[:attached_service][:variables_attributes]"
# p params[:attached_service][:variables_attributes]


#     value_lookup_for = {}
#     params[:attached_service][:variables_attributes].each do |k,v|
#       value_lookup_for[v[:name]] = v[:value]
#     end

#     variables_params.map do |variable|
#       {
#         name: variable[:name],
#         value: value_lookup_for[variable[:name]]),
#         label: variable[:label],
#         comment: variable[:comment],
#         type: variable[:type],
#         regex_validator: variable[:regex_validator],
#         regex_invalid_message: variable[:regex_invalid_message],
#         mandatory: variable[:mandatory] || variable[:required],
#         ask_at_build_time: variable[:ask_at_build_time],
#         build_time_only: variable[:build_time_only],
#         immutable: variable[:immutable],
#         tooltip: variable[:tooltip],
#         hint: variable[:hint],
#         placeholder: variable[:placeholder],
#         collection: variable[:collection]
#       }
#     end

#   end

  def new_attached_service_variable_attributes

    variables_params = service_detail params[:service_type], params[:service_provider]

    variables_params.map do |variable|
      {
        name: variable[:name],
        value: variable[:value],
        label: variable[:label],
        comment: variable[:comment],
        type: variable[:type],
        regex_validator: variable[:regex_validator],
        regex_invalid_message: variable[:regex_invalid_message],
        mandatory: variable[:mandatory] || variable[:required],
        ask_at_build_time: variable[:ask_at_build_time],
        build_time_only: variable[:build_time_only],
        immutable: variable[:immutable],
        tooltip: variable[:tooltip],
        hint: variable[:hint],
        placeholder: variable[:placeholder],
        collection: variable[:collection]
      }
    end
  end

  # def 
  #   @volumes = EnginesSoftware.volumes(@software.engine_name).map(&:name)
  #   @databases = EnginesSoftware.databases(@software.engine_name).map(&:name)
  # end

end