class Install < ActiveRecord::Base

      attr_accessor :host_name
      attr_accessor :host_domain

      # has_many :env_variables

      # accepts_nested_attributes_for :env_variables

attr_accessor :environment_variable_test


end
