class ApplicationInstallationsController < ApplicationController

  include ActionController::Live
  include Engines::Api

  def preparing_installation
    @application_name = params[:application_name]
  end

  def preparing_installation_progress
    if System.waiting_for_installation
      render text: 'busy'
    else
      render text: 'done'
    end
  end

  def installing
    # if @system_status[:state] == :installing
      @application_installation_progress = ApplicationInstallationProgress.load
    # else
      # redirect_to control_panel_path, alert: "Not installing."
    # end
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
  ensure
    send_event :message, 'done'
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
          break
        end

      end
    end
  end

  def send_installation_report
    ApplicationInstallationProgress.new(application_name: params[:application_name]).installation_report_lines.each do |line|
      send_event :installation_report, line
    end
  end

  def send_event(event, data='')
       response.stream.write "event: #{event}\n"
       response.stream.write "data: #{data}\n\n"
  end

  def application_installation_params
    params.require(:application_installation).permit!
  end

end
