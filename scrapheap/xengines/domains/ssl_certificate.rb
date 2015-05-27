module Engines::Domains

    class SslCertificate

      def engines_api
        @enignes_api ||= Engines::System.api
      end

      def self.create params
        engines_api.create_ssl_certificate params
      end
   
  end
  
end
