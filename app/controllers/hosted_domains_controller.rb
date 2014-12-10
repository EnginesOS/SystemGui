class HostedDomainsController < ApplicationController
  before_action :authenticate_user!

  attr_accessor :old_domain_name

  def index
    @hosted_domains = HostedDomain.refresh_db_and_load_all.sort_by{|d| d.domain_name}
  end

  def new
    @hosted_domain = HostedDomain.new
  end

  def edit
    @hosted_domain = HostedDomain.find(params[:id])
  end

  def update
    @hosted_domain = HostedDomain.find(params[:id])
    @hosted_domain.update_via_api(hosted_domain_params)
    redirect_to hosted_domains_path
  end

  def create
    @hosted_domain = HostedDomain.new(hosted_domain_params)
    validation_result = @hosted_domain.validate_domain_name_not_blank
    if validation_result != 'OK'
      redirect_to new_hosted_domain_path(hosted_domain_params), alert: 'Domain name cannot be blank.'
    elsif @hosted_domain.save_via_api
      redirect_to hosted_domains_path, notice: 'Successfully created self-hosted domain.'
    else
      redirect_to new_hosted_domain_path(hosted_domain_params), alert: 'Unable to save self-hosted domain.'
    end
  end

  def destroy
    @hosted_domain = HostedDomain.find(params[:id])
    @hosted_domain.destroy_via_api
    redirect_to hosted_domains_path
  end

private

  def hosted_domain_params
    params.require(:hosted_domain).permit!
  end

end
