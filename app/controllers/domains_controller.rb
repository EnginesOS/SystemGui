class DomainsController < ApplicationController

  include EnginesDomainsActions

  before_action :authenticate_user!

  def index
    EnginesMaintenance.reload_domains
    @domains = Domain.all.sort_by{|d| d.domain_name}
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

  def create
    @domain = Domain.new(domain_params)
    result = @domain.api_create
    if result == true
      redirect_to domains_path, notice: 'Successfully created self-hosted domain.'
    else
      render :new
    end
  end

  def destroy
    @domain = Domain.find(params[:id])
    if !@domain.delete
      redirect_to domains_path, alert: 'Unable to delete domain.'
    else
      result = @domain.destroy_via_api
      if result.was_success
        redirect_to domains_path, notice: 'Successfully deleted domain.'
      else
        redirect_to domains_path, alert: ('Unable to delete domain. ' + result.result_mesg.to_s)[0..1000]
      end
    end
  end

private

  def domain_params
    params.require(:domain).permit!
  end

end
