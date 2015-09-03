class EnginesHelper::Forms::Errors
  
  include EnginesHelper::Base
  include ActionView::Helpers::TextHelper
  
  def initialize(template, form_builder, options={})
    @template = template
    @form_builder = form_builder
    @form_object = form_builder.object
    @errors = @form_object.errors
    @errors <<  ["Engines system error", @form_object.engines_api_error] if (@form_object.respond_to?(:engines_api_error) && @form_object.engines_api_error.any?)
    # @object_name = options[:object_name] || @form_object.class.to_s.humanize.downcase
    # @action = options[:action] || :save
    @offset = options[:offset] || 2
    @width = options[:width] || 8
    @class = [options[:class], 'form_errors', "col-sm-offset-#{@offset}", "col-sm-#{@width}"].compact.join(' ')
  end

  def render
    div(class: 'row'){render_errors}
  end
  
  private

  def render_errors
    div class: @class do
      div class: 'alert alert-warning alert-dismissible' do
        [ button(class: 'close', data: {dismiss: 'alert'}){span{'×'}},
          strong{pluralize @form_object.errors.count, "error"},
          ul{@errors.map{ |attribute, error| li{ (error.class == Array ? error : [attribute.to_s.humanize, error]).join ' ' }}.render}
        ].render
      end
    end if @errors.any?
  end

end

