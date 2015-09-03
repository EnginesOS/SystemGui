class DomainsManagersController < ApplicationController

  before_action :authenticate_user!

  def show
    @domain_settings = DomainSettings.load
    @domains = Domain.load_all
  end
  
end
