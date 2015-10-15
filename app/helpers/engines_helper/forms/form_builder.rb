class EnginesHelper::Forms::FormBuilder < ActionView::Helpers::FormBuilder
  
  include EnginesHelper::Forms
  
  def form_input(name, options={})
    Input.new(@template, self, name, options).render
  end
  
  def form_submit(options={})
    Submit.new(@template, self, options).render
  end

  def form_errors  
    Errors.new(@template, self, options).render
  end

end
