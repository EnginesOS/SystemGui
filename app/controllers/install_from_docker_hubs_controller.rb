class InstallFromDockerHubsController < ApplicationController

  include ActionController::Live

  before_action :authenticate_user!

  def new
    @install_from_docker_hub = InstallFromDockerHub.build_new
  end

  def create
    # render text: params
    @install_from_docker_hub = InstallFromDockerHub.new(install_from_docker_hub_params)
    if @install_from_docker_hub.ready_to_install?
      install_software
    else
      render :new
    end
  end

    
    # if @install_from_docker_hub.new_application_service?
      # render :new
    # elsif @install_from_docker_hub.new_eport?
      # render :new
    # elsif @install_from_docker_hub.new_environment_variable?


  # def application_service
    # @application = Application.new
    # @application.application_services.build #(application_service_params) #.load_variable_definitions
# 
    # render text: @application.application_services.build(application_service_params).load_variable_definitions
# 
    # # render partial: 'application_service'
  # end

  # def set_application_service
    # @application_service ||= @application.application_services.build(application_service_params)
  # end

  # def new_attached_service
#     
    # params[:form_data]
#     
    # render text: "<p>#{params}</p>"
# 
# 
    # # @software = DockerHubInstall.new_software_for_attached_service
    # # @software.attached_services_handler.attached_services.build(new_attached_service_attributes)
    # # render partial: 'new_attached_service'
  # end

  # def create
    # @software = Software.new(software_install_params)
    # attached_services_handler = @software.attached_services_handler || @software.build_attached_services_handler
    # if @software.docker_hub_install.new_attached_service_publisher_namespace.present?
      # attached_services_handler.attached_services.build(new_attached_service_attributes)
      # @software.docker_hub_install.new_attached_service_publisher_namespace = nil
      # @software.docker_hub_install.new_attached_service_type_path = nil
      # @software.docker_hub_install.scroll_form_to = "#docker_hub_install_new_attach_services_button"
      # render :new
    # elsif @software.docker_hub_install.new_eport.present?
      # @software.eports.build
      # @software.docker_hub_install.new_eport = nil
      # @software.docker_hub_install.scroll_form_to = "#docker_hub_install_new_eport_button"
      # render :new
    # elsif @software.docker_hub_install.new_environment_variable.present?
      # @software.docker_hub_install.variables.build
      # @software.docker_hub_install.new_environment_variable = nil
      # @software.docker_hub_install.scroll_form_to = "#docker_hub_install_new_environment_variable_button"
      # render :new
    # else
      # if @software.valid?
    # # render text: engine_installation_params
# 
        # create_engine_build
      # else
        # @software.docker_hub_install.new_eport = nil
        # @software.docker_hub_install.new_attached_service_publisher_namespace = nil
        # @software.docker_hub_install.new_attached_service_type_path = nil
        # @software.docker_hub_install.scroll_form_to = nil
        # render :new
      # end
    # end
  # end
# 
  def install_software
    # render text: "gui needs method to pass these params to...\n" + @install_from_docker_hub.installation_params.to_s
    Thread.new do
      @install_from_docker_hub.install
    end
    redirect_to preparing_installation_application_installation_path(
      # software_name: @install_from_docker_hub.docker_image, 
      application_name: @install_from_docker_hub.application.container_name
      # host_name: @install_from_docker_hub.application.application_network_properties.host_name,
      # domain_name: @install_from_docker_hub.application.application_network_properties.domain_name
      )
  end

private

  def install_from_docker_hub_params
    @software_install_params ||= params.require(:install_from_docker_hub).permit!
  end
  
  # def application_service_params
    # params.require(:application_service).permit(:publisher_namespace, :type_path)
  # end
  
  # def new_attached_service_attributes
    # type_path = @software.docker_hub_install.new_attached_service_type_path
    # publisher_namespace = @software.docker_hub_install.new_attached_service_publisher_namespace
    # # service_detail = @software.build_attached_services_handler.service_detail(params[:new_attached_service_type_path], params[:new_attached_service_publisher_namespace])
    # attached_service_service_detail = @software.attached_services_handler.service_detail type_path, publisher_namespace
    # {
      # type_path: type_path,
      # publisher_namespace: publisher_namespace,
      # title: attached_service_service_detail[:title],
      # description: attached_service_service_detail[:description],
      # variables_attributes: (attached_service_service_detail[:consumer_params].values if attached_service_service_detail[:consumer_params].present?)
    # }
  # end
#   

#   
  # def engine_installation_attached_services_params
    # if software_install_params[:attached_services_handler_attributes].present?
      # software_install_params[:attached_services_handler_attributes][:attached_services_attributes].values.map do |attached_service|
        # result = {
          # type_path: attached_service[:type_path],
          # publisher_namespace: attached_service[:publisher_namespace]
        # }
        # attached_service[:variables_attributes].values.each do |variable|
          # result[variable[:name]] = variable[:value]
        # end
        # result
      # end
    # else
      # []
    # end
  # end
# 
  # def engine_installation_environment_variables
    # if software_install_params[:docker_hub_install_attributes].present? && software_install_params[:docker_hub_install_attributes][:variables_attributes]
      # software_install_params[:docker_hub_install_attributes][:variables_attributes].values.map do |environment_variable|
        # if environment_variable[:name].blank? || environment_variable[:value].blank? || environment_variable[:_destroy] == "1"
          # {}
        # else
          # {
            # environment_variable[:name] => environment_variable[:value]
          # }
        # end
      # end.inject(:merge)
    # else
      # {}
    # end
  # end
# 
# 
  # def engine_installation_eports_params
    # if software_install_params[:eports_attributes].present?
      # software_install_params[:eports_attributes].map do |key, eport|
        # if (eport[:name].blank? ||
            # eport[:internal_port].blank? ||
            # eport[:external_port].blank? ||
            # eport[:protocol].blank? ||
            # eport[:_destroy] == "1" )
          # nil
        # else
          # {
            # name: eport[:name],
            # internal_port: eport[:internal_port],
            # external_port: eport[:external_port],
            # protocol: eport[:protocol]
          # }
        # end
      # end.compact
    # else
      # []
    # end
  # end


end

