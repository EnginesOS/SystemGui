ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| 
  "<span class=\"field_with_errors\">#{html_tag}</span>".html_safe
}