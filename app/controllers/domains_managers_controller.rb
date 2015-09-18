class DomainsManagersController < ApplicationController


  def show
    @domain_settings = DomainSettings.load
    @domains = Domain.load_all
  end
  
end
