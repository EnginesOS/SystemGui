class ServiceAction

  def self.list_actionators_for(container_name)
    Service.load_by_container_name(container_name).actionators
  end

  def initialize params
    @service_name = params[:id]
    @action_name = params[:action_name]
    @value_name = params[:value_name]
  end

  def value
    Service.load_by_container_name(@service_name).action_result_for(@action_name)
  end

end
