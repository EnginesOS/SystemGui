class ApplicationReportsController < ApplicationController


  def show
    @application = Application.find_by(container_name: application_name)
    render layout: false
  end
  
  def installation_report
    @application = Application.find_by(container_name: application_name)
    render layout: "empty_navbar"
  end

private

  def application_name
    params[:application_name]
  end

end