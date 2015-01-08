module FormsHelper

  def form_errors(form_builder, opts = {})
    if form_builder.object.errors.any?
      content_tag(:div, class: "panel panel-danger") do
        concat(content_tag(:div, class: "panel-heading") do
          concat(content_tag(:h4, class: "panel-title") do
            concat "#{pluralize(form_builder.object.errors.count, "error")} prohibited the #{ opts[:name] || form_builder.object.class.name.downcase} from being saved:"
          end)
        end)
        concat(content_tag(:div, class: "panel-body") do
          concat(content_tag(:ul) do
            form_builder.object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end

  def form_field(form_builder, field_name, opts={})
    render partial: 'shared/form/field', locals: {field_name: field_name, f: form_builder, label: opts[:label]}
  end



end
