class Variable < ActiveRecord::Base

  attr_accessor(
    :name,
    :value,
    :value_confirmation,
    :label,
    :field_type,
    :select_collection,
    :tooltip,
    :hint,
    :placeholder,
    :comment,
    :regex_validator,
    :regex_invalid_message,
    :mandatory,
    :ask_at_build_time,
    :build_time_only,
    :immutable,
    :missing_from_definition
  )
  
  belongs_to :variable_consumer, polymorphic: true

  validate :regex_validation
  validate :value_confirmation_validation
  validate :value_present_validation
  # validate :test_vali
# 
  # def test_vali
    # errors.add(name, [label, "oops"])
  # end

private

  def regex_validation
    if (regex_validator.present? && !Regexp.new(regex_validator.to_s).match(value.to_s))
      errors.add(name, [label, regex_invalid_message] || [label, "is invalid. (Expects regex /#{regex_validator}/ but got `#{value}` from user.)"])
    end
  end

  def value_present_validation
    if (mandatory.to_s == "true" && value.blank?)
      errors.add(name, [label, "must not be blank"])
    end
  end

  def value_confirmation_validation
    if (field_type == "password_with_confirmation" && value != value_confirmation)
      errors.add(name, ["Passwords", "must match"])
    end
  end

end
