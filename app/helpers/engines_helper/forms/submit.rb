class EnginesHelper::Forms::Submit

  include EnginesHelper::Base

  def initialize(template, form_builder, options={})
    @template = template
    @form_builder = form_builder
    @form_object = form_builder.object
    @offset = options[:offset] || 2
    @width = options[:width] || 8
    @cancel_url = options[:cancel_url] || '/'
    @class = [options[:class], "col-sm-offset-#{@offset}", "col-sm-#{@width}"].compact.join(' ')
    @submit_fa = options[:submit_fa] || 'check'
    @submit_label = options[:submit_label] || (@form_object.new_record? ? 'Create' : 'Update')
    @cancel_fa = options[:cancel_fa] || 'times'
    @cancel_label = options[:cancel_label] || 'Cancel'
  end

  def render
    div class: @class do
      div class: 'form-buttons form-group top-gap' do
        [render_cancel_button, render_submit_button].render
      end
    end
  end

  private

  def render_cancel_button  
    div class: 'btn-group pull-left' do
      btn_link(@cancel_url, :warning, no_spinner: true, class: 'form-button-cancel'){ fa(@cancel_fa) + ' ' + @cancel_label }
    end
  end

  def render_submit_button  
    div class: 'btn-group pull-right' do
      btn_button(:primary, type: :submit, no_spinner: true, class: 'form-button-submit'){ fa(@submit_fa) + ' ' + @submit_label }
    end
  end

end