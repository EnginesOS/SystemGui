class DomainsController < ApplicationController

  before_action :authenticate_user!

  include EnginesDomainsActions

  before_action :set_settings, only: [:edit_default_domain, :edit_default_website, :update_network_settings]

  def index
    EnginesMaintenance.domains_maintenance
    @domains = Domain.all.sort_by{|domain| domain.domain_name}
    @settings = Setting.first_or_create
  end

  def new
    @domain = Domain.new
  end

  def edit
    @domain = Domain.find(params[:id])
  end

  def update
    @domain = Domain.find(params[:id])
    @domain.update(domain_params)
    @domain.api_save
    redirect_to domains_path
  end

  def update_network_settings
    if (@settings.update(settings_params) && @settings.update_engines(settings_params))
      redirect_to domains_path, notice: 'Network settings were successfully saved.'
    else
      redirect_to domains_path, alert: 'Network settings were not saved.'
    end
  end


  def create
    @domain = Domain.new(domain_params)
    result = @domain.api_create
    if result == true
      redirect_to domains_path, notice: 'Successfully created domain.'
    else
      render :new
    end
  end

  def destroy
    @domain = Domain.find(params[:id])
    if !@domain.delete
      redirect_to domains_path, alert: 'Unable to delete domain.'
    else
      result = @domain.api_destroy
      if result.was_success
        redirect_to domains_path, notice: 'Successfully deleted domain.'
      else
        redirect_to domains_path, alert: ('Unable to delete domain. ' + result.result_mesg.to_s)[0..1000]
      end
    end
  end

private

  def set_settings
    @settings = Setting.first_or_create
  end

  def domain_params
    params.require(:domain).permit!
  end

  def settings_params
    params.require(:setting).permit!
  end
  
end
