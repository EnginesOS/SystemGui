class DomainsManagersController < ApplicationController

  def show
    @domain_default_name = DomainDefaultName.load
    @domain_default_site = DomainDefaultSite.load
    @domains = Domain.load_all
  end
  
end
