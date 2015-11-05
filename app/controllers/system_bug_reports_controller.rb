class SystemBugReportsController < ApplicationController

  def edit
    @system_bug_reports = SystemBugReports.new 
  end
  
  def update
    SystemBugReports.new(enable: params[:system_bug_reports][:enable]).persist
    redirect_to system_path
  end
  

end
