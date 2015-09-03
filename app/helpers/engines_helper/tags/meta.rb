module EnginesHelper::Tags::Meta

  def self.html_methods
    [:div, :span, :strong, :ul, :li, :h2]
  end

  def self.define_html_method(method_name)
    define_method(method_name){|options={}, &block| scope.content_tag(method_name, class: options[:class]){block.call}.html_safe}
  end
  
  def self.define_html_methods
    html_methods.each do |method_name|
      define_html_method method_name
    end
  end

  self.define_html_methods
  
end