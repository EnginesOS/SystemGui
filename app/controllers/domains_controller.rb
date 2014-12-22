class DomainsController < ApplicationController

  include EnginesDomainsActions

  before_action :authenticate_user!

  def index
    @domains = Domain.refresh_db_and_load_all.sort_by{|d| d.domain_name}
  end

  def new
    @domain = Domain.new
  end

  def edit
    @domain = Domain.find(params[:id])
  end

  def update
    @domain = Domain.find(params[:id])
    @domain.update_via_api(domain_params)
    redirect_to domains_path
  end

  def create
    @domain = Domain.new(domain_params)
    validation_result = @domain.validate_domain_name_not_blank
    if validation_result != 'OK'
      redirect_to new_domain_path(domain_params), alert: 'Domain name cannot be blank.'
    elsif @domain.save_via_api
      redirect_to domains_path, notice: 'Successfully created self-hosted domain.'
    else
      redirect_to new_domain_path(domain_params), alert: 'Unable to save self-hosted domain.'
    end
  end

  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy_via_api
    redirect_to domains_path
  end


private

  def domain_params
    params.require(:domain).permit!
  end

end
