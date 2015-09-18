class ServiceReportsController < ApplicationController


  def show
    @service = Service.new(container_name: service_name)
    render layout: false
    # render text: :hi
  end

private

  def service_name
    params[:service_name]
  end

end