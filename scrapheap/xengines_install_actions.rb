def EnginesInstallActions
  
    def send_progress(engine_name)
      response.headers['Content-Type'] = 'text/event-stream'
      send_event :installation_progress, "Starting build...\n"
      File.open('/home/engines/deployment/deployed/build.out') do |f|
        f.extend(File::Tail)
        f.interval = 10
        f.backward(10000)
        f.tail do |line|
          # p line
          send_event :installation_progress, line
          break if line.start_with?("Build Finished")
        end
      end
      EnginesInstaller.installation_report_lines(engine_name).each do |line|
        send_event :installation_report, line
      end
    ensure
      send_event :message, "close"
      response.stream.close
    end
  
  private
  
    def send_event(event, data='a')
         response.stream.write "event: #{event}\n"
         response.stream.write "data: #{data}\n\n"
    end
    
end
