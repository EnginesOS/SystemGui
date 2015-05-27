module Engines::Domains

    class Domain

      include Engines::Api

      attr_accessor :key

      def initialize(domain_name_key)
        @key = domain_name_key
      end

      # def self.new_from_key domain_name_key
        # self.new domain_name_key.gsub('%', '.')
      # end

      def domain_name
        @domain_name ||= Engines::Domains.domain_name_from_key(@key)      
      end

      def internal_only
        Engines::Domains.domain_names_hash[domain_name][:internal_only]
      end

      def self_hosted
        Engines::Domains.domain_names_hash[domain_name][:self_hosted]
      end

      def update(params)
        engines_api.update_domain(
          "original_domain_name" => domain_name,
          "domain_name" => params[:domain_name],
          "internal_only" => params[:internal_only] == "1",
          "self_hosted" => params[:self_hosted] == "1" )
      end

      def destroy
        engines_api.remove_domain(
        {domain_name: @domain_name } )
      end

   end

end