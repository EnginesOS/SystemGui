module Engines::Domain

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def engines_api
      Engines::Api.instance.engines_api
    end

    def domain_names_list
      domain_names_hash.values.map{|v| v["domain_name"]}.compact.sort
    end

    def domain_names_hash
      @domain_names_hash ||= engines_api.list_domains
    end
  end

  def engines_api
    self.class.engines_api
  end

	

end
