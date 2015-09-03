class Forms::FormBuilder < ActionView::Helpers::FormBuilder
  def input(name, options={})
    Forms::Input.new(@template, self, name, options).render
  end
end
