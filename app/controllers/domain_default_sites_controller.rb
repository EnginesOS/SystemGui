class DomainDefaultSitesController < ApplicationController

  def edit
    @domain_default_site = DomainDefaultSite.load
  end

  def update
    @domain_default_site = DomainDefaultSite.new(domain_default_site_params)
    if @domain_default_site.update
      redirect_to domains_manager_path, notice: "Successfully updated default site."
    else
      render :edit
    end
  end

private

  def domain_default_site_params
    @domain_default_site_params ||= params.require(:domain_default_site).permit!
  end
  
end
