require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module EngosControl
  class Application < Rails::Application
    GC::Profiler.enable
  end
end
