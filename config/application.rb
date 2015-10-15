require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

# Rails.application.configure do
  # config.autoload_paths << Rails.root.join('lib')
# end



module EnginesSystemGUI
  class Application < Rails::Application
    GC::Profiler.enable
  end
end

ActionView::Base.default_form_builder = 'EnginesHelper::Forms::FormBuilder'

