class EnginesHelper::Forms::Input

  include EnginesHelper::Base

  def initialize(template, form_builder, name, options={})
    @template = template
    @form_builder = form_builder
    @name = name.to_sym
    @label = options[:label].nil? ? name.to_s.humanize.capitalize : options[:label]
    @tooltip = options[:tooltip]
    @value = options[:value].nil? ? form_builder.object.send(name) : options[:value]
    @value = nil if @value.blank? #placeholder is visible only when value is nil
    @hint = options[:hint]
    @placeholder = options[:placeholder]
    @comment = options[:comment]
    @errors = ( options[:errors] || form_builder.object.errors[name] ).map{ |error| error.class == Array ? error[1] : error }
    @as = options[:as].to_sym if options[:as].present?
    @select_collection = options[:select_collection]
    @select_collection_value_method = options[:select_collection_value_method] || :to_s
    @select_collection_label_method = options[:select_collection_label_method] || :to_s
    # @nest_in = options[:nest_in]
    @offset = options[:offset] || 2
    @width = options[:width] || 8
    @buffer = options[:buffer] || 2
    @class = [options[:class], ('field_with_errors' if @errors.present?), "col-sm-offset-#{@offset}", "col-sm-#{@width}"].compact.join(' ')
    @area_rows = options[:rows] || 4
  end

  def render
    [render_form_group, render_buffer].join.html_safe
  end
  
  private

  def render_form_group
    @template.content_tag :div, class: @class do
      @template.content_tag :div, class: 'form-group'  do
        [render_label, render_comment, render_input, render_hint_and_errors].join.html_safe
      end
    end
  end

  def render_input
    send("render_#{input_type}")
  end
  
  def common_field_options
    {
      value: @value,
      title: @tooltip,
      placeholder: @placeholder,
      class: 'form-control input-lg'
    }
  end

  def render_text_field
    @form_builder.text_field(@name, common_field_options).html_safe
  end

  def render_text_area
    @form_builder.text_area(@name, common_field_options.merge(rows: @area_rows)).html_safe
  end

  def render_code_area
    @form_builder.text_area(@name, common_field_options.merge(rows: @area_rows, style: 'font-family:courier;', spellcheck: 'false')).html_safe
  end

  def render_radio_buttons
    @form_builder.collection_radio_buttons  @name, 
                                            @select_collection,
                                            @select_collection_value_method,
                                            @select_collection_label_method,
                                            {checked: @value}, {title: @tooltip} do |radio|
     radio.label(class: 'form-text-lg', style: 'display: block;', :'data-value' => radio.value) { radio.radio_button + ' ' + radio.text }
    end
  end

  def render_file_field
    f.file_field :icon
  end


  def render_label
    @form_builder.label(@name, class: 'control-label'){@label}.html_safe if @label.present?
  end

  def render_comment
    @template.content_tag(:small){@comment}.html_safe
  end

  def render_errors
      @template.content_tag(:div, class: 'form-field-errors'){@errors.join(', ')}.html_safe
  end

  def render_hint
    @template.content_tag(:div, class: 'form-field-hint'){@hint}.html_safe
  end

  def render_hint_and_errors
    @errors.present? ? render_errors : @hint.present? ? render_hint : nil
  end
  
  def render_buffer
    @template.content_tag(:div, class: "col-sm-#{@buffer} grid-buffer-col"){'&nbsp'.html_safe}.html_safe
  end
  
  def attribute_type
    attribute_detail = @form_builder.object.class.columns_hash[@name.to_s]

      # <%= f.object.class.columns_hash.map(&:first).find{|column_name| column_name.ends_with? '_file_name' }[0..-11] %>



    if attribute_detail
      # if name == (nest_in.to_s.underscore + '_id').to_sym ||
      # name.to_s.ends_with?('_consumer_type' )
      # :hidden
      # else
      attribute_detail.type.to_sym
      # end

    end
  end

  def input_type
    case (@as || attribute_type)
    when :boolean, :checkbox
      'checkbox'
    when :decimal, :float, :integer, :binary, :enum, :number_field, :number
      'number_field'
    when :time, :timestamp
      'time_field'
    when :date, :date_field
      'date_field'
    when :datetime, :datetime_field
      'datetime_field'
    when :code, :code_area, :code_box
      'code_area'
    when :text, :text_area
      'text_area'
    when :hidden, :hidden_field
      'hidden_field'
    when :select, :select_single
      'select'
    when :radios, :radio_buttons
      'radio_buttons'
    else
      'text_field'
    end
  end


end
 
      
      
      
    # end


 
  
  
  # def field(name, options={})
# 
    # label = options[:label].nil? ? name.to_s.humanize.capitalize : options[:label]
    # tooltip = options[:tooltip] || false
    # value = options[:value].nil? ? f.object.send(name) : value
    # value = nil if value.blank? #placeholder is visible to user only when value is nil
    # hint ||= nil
    # placeholder ||= nil
    # comment ||= nil
    # errors ||= f.object.errors[name]
    # errors_class = "field_with_errors" if errors.present?
#   
  # end

# field_type = f.object.field_type.present? ? f.object.field_type : 'text_field'
# name = f.object.name
# label = f.object.label.present? ? f.object.label : f.object.name.humanize
# comment = f.object.comment
# hint = f.object.hint
# tooltip = f.object.tooltip
# value = f.object.value
# collection = f.object.select_collection
# mandatory = f.object.mandatory.to_s
# mandatory = (mandatory == "true")
# placeholder = f.object.placeholder
# errors = f.object.errors[name]
# field_class = mandatory ? "" : "advanced_fields"
# 
# if f.object.select_collection.present?
# select_collection <%= f.object.select_collection %> present, of class <%= f.object.select_collection.class %>.
# end %>
# <div class="row <%= field_class %>">
# 
    # <div class="">
    # <% if field_type == 'text_field' || field_type == 'string' || field_type == 'text' %>
      # <%= render partial: 'shared/form/text_field', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'text_area' %>
      # <%= render partial: 'shared/form/text_area', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'checkbox' || field_type == 'boolean' %>
      # <%= render partial: 'shared/form/checkbox', locals: {name: :value, errors: errors, label: label, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'select_radio' || field_type == 'radio_buttons' %>
      # <%= render partial: 'shared/form/radio_buttons', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, collection: collection, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'select' || field_type == 'select_single' %>
      # <%= render partial: 'shared/form/select', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, collection: collection, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'country_select' %>
      # <%= render partial: 'shared/form/country_select', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, collection: collection, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'select_multi' %>
      # <%= render partial: 'shared/form/select_multi', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, collection: collection, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'password_with_confirmation' %>
      # <%= render partial: 'shared/form/password_with_confirmation', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, collection: f.object.select_collection, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'password' %>
      # <%= render partial: 'shared/form/password', locals: {name: :value, errors: errors, label: label, placeholder: placeholder, collection: f.object.select_collection, tooltip: tooltip, comment: comment, hint: hint, value: value, f: f} %>
    # <% elsif field_type == 'hidden' %>
      # <%= f.hidden_field :value %>
    # <% else %>
      # <div class="col-sm-8 col-sm-offset-2">
        # Error: '<%= field_type == 'boolean' %>' field type is not defined.
      # </div>
    # <% end %>
  # </div>
# 
# </div>