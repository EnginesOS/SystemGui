class ApplicationInstallationsController < ApplicationController

  include ActionController::Live
  include Engines::Api

  def preparing_installation
    @application_name = params[:application_name]
  end

  def preparing_installation_progress
    if System.waiting_for_installation_to_commence
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
p :installation_progress_done
    send_installation_report
p :installation_report_done
    send_event :message, 'done'
p :installation_done_done
  ensure
    response.stream.close
p :installation_stream_close_done
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
    p :event_data
    p event
    p data
       response.stream.write "event: #{event}\n"
       response.stream.write "data: #{data}\n\n"
  end

  def application_installation_params
    params.require(:application_installation).permit!
  end

end
