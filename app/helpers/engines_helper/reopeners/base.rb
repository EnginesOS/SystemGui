module EnginesHelper::Reopeners::Base

  Array.class_eval do
    def render(options={})
      compact.join(options[:join] || ' ').html_safe
    end
  end
  
  Hash.class_eval do
    def track(*keys)
      result = self[keys.shift]
      keys.empty? ? result : (result.is_a?(Hash) ? result.track(*keys) : nil)
    end
  end
  
end