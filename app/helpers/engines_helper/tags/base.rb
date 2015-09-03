module EnginesHelper::Tags::Base
  
  include EnginesHelper::Tags::Meta

  # def h2(heading_text, options={})
    # scope.content_tag(:h2){heading_text}.html_safe
  # end
  
  def fa(fa_icon_name, options={})
    scope.content_tag(:i, nil, class: "fa fa-#{fa_icon_name}").html_safe if fa_icon_name.present?
  end

  def button(options={}, &block)
    scope.button_tag block.call, type: (options[:type] || :button), class: options[:class], data: options[:data]
  end
  
  def link(url, options={}, &block)
    scope.link_to(url, options){block.call}  
  end
  
  def btn_link(url, flavor=:default, options={}, &block)
    btn_class = 'btn-' + flavor.to_s
    options[:class] = [
            options[:class].to_s,
            'btn btn-lg',
            btn_class, 
            ('trigger-response-modal' unless (options[:no_spinner] || options.track(:data, :confirm) ))
                      ].compact.join(' ')
    link(url, options){block.call}  
  end
  
  def btn_button(flavor = :default, options={}, &block)
    btn_class = 'btn-' + flavor.to_s
    options[:class] = [options[:class].to_s, 'btn btn-lg', btn_class, ('trigger-response-modal' unless (options[:no_spinner] || options.track(:data, :confirm) ))].compact.join(' ')
    button(options){block.call}  
  end
  
  def legend(legend_text)
    div(class: 'col-sm-12'){scope.content_tag :legend, legend_text}
  end

  # def form_legend(legend_text, options={})
    # Input.new(@template, self, name, options).render
  # end
  
  private
  
  def scope
    @template || self
  end

end