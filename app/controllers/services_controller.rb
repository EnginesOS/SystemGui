class ServicesController < ApplicationController

  include EnginesServicesActions

  before_action :authenticate_user!

  def advanced_detail
    @service_name = params[:id]
    render partial: "advanced_detail"
  end

  def services_trees
    @services_tree_by_provider = EnginesServiceConsumerManager.services_tree_by_provider
    @services_tree_by_engine = EnginesServiceConsumerManager.services_tree_by_engine
  end

end

