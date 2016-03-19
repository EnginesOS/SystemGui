class ServicesRegistriesController < ApplicationController


  def show
    @services_tree_by_provider = Service.services_tree_by_provider
    @services_tree_by_engine = Service.services_tree_by_engine
    @services_tree_of_orphaned_services = Service.services_tree_of_orphaned_services
    @services_tree_by_configurations = Service.services_tree_by_configurations
    @services_tree_by_shares = Service.services_tree_by_shares
  end    

private

  def application_name
    params[:application_name]
  end

end
