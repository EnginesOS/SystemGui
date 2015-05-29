module SharedViews
  
  extend ActionView::Helpers::DateHelper

  def self.resolve_value_for item, attribute, opts={}

    # nest_in = opts[:nest_in] || nil

    label_method = 
      if opts[:label_method].present?
        opts[:label_method].to_sym
      # elsif attribute.present?
      #   item.attribute
      elsif item.respond_to?(:to_label) || item.send(attribute).respond_to?(:to_label)
        :to_label
      else
        :to_s
      end

    attribute = attribute.to_sym

    if item.class.reflect_on_association(attribute) && item.class.reflect_on_association(attribute).options[:polymorphic]
      result = item.send(attribute.to_s + '_type').camelize.constantize.find(item.send(attribute.to_s + '_id')).send(label_method)

    else
      result = item.send(attribute)
      if result.class.superclass == ActiveRecord::Associations::CollectionProxy
        if result.count > 5
          overflow_count = result.count - 5
        end 
        result = result.map{|record|record.send(label_method)}.first(5).join('<br>').html_safe 
        result += "<br>+ #{overflow_count} more".html_safe if overflow_count
      elsif result.class.superclass == ActiveRecord::Base 
        result = result.send(label_method)
      end 
    end 
    result

  end

  def self.value_as_html value
    case value
    when TrueClass || "true"
        '<i class="fa fa-check"></i>'.html_safe
    when FalseClass || "false"
        '<i class="fa fa-times"></i>'.html_safe
      when ActiveSupport::TimeWithZone
        distance_of_time_in_words_to_now(value) + ' ago'
      else
        value
    end
  end

  def self.awesome_print value
    (ap JSON.parse(value.to_json), plain: true, index: false).html_safe
  end

end