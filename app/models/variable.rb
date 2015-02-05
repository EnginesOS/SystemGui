class Variable < ActiveRecord::Base

  attr_accessor(
    :name,
    :value,
    :value_confirmation,
    :label,
    :comment,
    :type,
    :regex_validator,
    :regex_invalid_message,
    :mandatory,
    :ask_at_build_time,
    :build_time_only,
    :immutable,
    :tooltip,
    :hint,
    :placeholder,
    :collection
  )

  belongs_to :variable_consumer, polymorphic: true

  # domain_name_regex = /^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+([a-zA-Z0-9]{2,5})$/
  # validates :value, format: { with: domain_name_regex, :multiline => true  }

  validate :regex_validation
  validate :value_confirmation_validation
  validate :value_present_validation
  # validate :a_validation

  def regex_validation
    if (regex_validator.present? && !Regexp.new(regex_validator.to_s).match(value.to_s))
      errors.add(name, [label, regex_invalid_message] || [label, "is invalid. (Expects regex /#{regex_validator}/ but got `#{value}` from user.)"])
    end
  end

  def value_present_validation
    if (mandatory == true && value.blank?)
      errors.add(name, [label, "must not be blank"])
    end
  end

  def value_confirmation_validation
    if (type == "password_with_confirmation" && value != value_confirmation)
      errors.add(name, ["Passwords", "must match"])
    end
  end

end
