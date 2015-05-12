module EnginesSystem::ManagedServices
   
    class Definition
      def initialize(params)
        @publisher_namespace = params[:publisher_namespace]
        @type_path = params[:type_path]
      end
  
      def detail
        engines_api.software_service_definition(
        publisher_namespace: @publisher_namespace,
        type_path: @type_path)
      end
    
      def setup_params
        detail[:setup_params]
      end
    
      def consumer_params
        detail[:consumer_params]
      end
      
      
    private

  
    end


end