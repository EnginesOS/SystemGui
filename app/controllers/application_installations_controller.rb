class ApplicationInstallationsController < ApplicationController

  include ActionController::Live
  include Engines::Api

  def preparing_installation
    @application_name = params[:application_name]
  end

  def preparing_installation_progress
    if @system_status[:state] == :install_failed
      SystemDataCache.clear_failed_build_flag
      render text: 'done'
    elsif @system_status[:state] == :installing
      render text: 'busy'
    else
      render text: 'done'
    end
  end

  def installing
    @application_installation_progress = ApplicationInstallationProgress.load
    redirect_to control_panel_path,
        alert: "Last install not available." if
          @application_installation_progress.application_name.blank?
  end

  def cancel
    System.cancel_installation
    redirect_to control_panel_path, alert: "Installation cancelled."
  end

  def progress
    response.headers['Content-Type'] = 'text/event-stream'
    send_event :installation_progress, "Starting build...\n"
    send_installation_progress
    send_installation_report
    send_event :message, 'done'
  ensure
    response.stream.close
  end

private

  def send_installation_progress
    previous_line = ''
    File.open('/home/engines/deployment/deployed/build.out') do |f|
      f.extend(File::Tail)
      f.interval = 10
      f.backward(10000)
      f.tail do |line|
        send_event :installation_progress, line
        if line.start_with?('Build Finished')
          return
        end
      end
    end
  end

  def send_installation_report
    ApplicationInstallationProgress.new(application_name: params[:application_name]).installation_report_lines.each do |line|
      # line = '' if line.blank?
      send_event :installation_report, line
    end
  rescue
  end

  def send_event(event, data='')
       response.stream.write "event: #{event}\n"
       response.stream.write "data: #{data}\n\n"
  end

  def application_installation_params
    params.require(:application_installation).permit!
  end

end
