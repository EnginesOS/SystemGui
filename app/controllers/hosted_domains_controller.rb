class HostedDomainsController < ApplicationController
  before_action :authenticate_user!

  def index
    @hosted_domains = HostedDomain.all
  end

  def new
    @hosted_domain = HostedDomain.new
  end

  def edit
    @hosted_domain = HostedDomain.find(params[:id])
  end

  def update
    @hosted_domain = HostedDomain.find(params[:id])
    @hosted_domain.update(hosted_domain_params)
    redirect_to hosted_domains_path
  end

  def create
    @hosted_domain = HostedDomain.new(hosted_domain_params)
    @hosted_domain.save_via_api
    redirect_to hosted_domains_path
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
