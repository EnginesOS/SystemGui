class Variable < ActiveRecord::Base

def debug
    {   name: name,
        value: value,
        value_confirmation: value_confirmation,
        label: label,
        field_type: field_type,
        select_collection: select_collection,
        tooltip: tooltip,
        hint: hint,
        placeholder: placeholder,
        comment: comment,
        regex_validator: regex_validator,
        regex_invalid_message: regex_invalid_message,
        mandatory: mandatory,
        ask_at_build_time: ask_at_build_time,
        build_time_only: build_time_only,
        immutable: immutable,
        missing_from_definition: missing_from_definition,
        skip_validations: skip_validations
    }.to_s
  end

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
    :missing_from_definition,
    :skip_validations
  )

  belongs_to :variable_consumer, polymorphic: true

  validate :regex_validation
  validate :value_confirmation_validation
  validate :value_present_validation

  def name_value_pair
    if (field_type.to_sym == :boolean || field_type.to_sym == :checkbox)
        self.value = true if value == "1"
        self.value = false if value == "0"
    end
    { name.to_sym => value }
  end

private

  def do_validations?
    !(skip_validations == "1")
  end

  def regex_validation
    if (do_validations? && value.present? && regex_validator.present? && !Regexp.new(regex_validator.to_s).match(value.to_s))
      errors.add(name, [label, regex_invalid_message] || [label, "is invalid. (Expects regex /#{regex_validator}/ but got `#{value}` from user.)"])
    end
  end

  def value_present_validation
    if (do_validations? && mandatory.to_s == "true" && value.blank?)
      errors.add(name, [label, "must not be blank"])
    end
  end

  def value_confirmation_validation
    if (do_validations? && field_type == "password_with_confirmation" && value != value_confirmation)
      errors.add(name, ["Passwords", "must match"])
    end
  end

end
