module ApplicationHelper
  require 'EnginesOSapi.rb'
   def getEnginesOSAPI  
     @enginesOS_api = EnginesOSapi.new
   end
   
   def enginesOS_api
      if @enginesOS_api == nill
        getEnginesOSAPI 
      end
     return @enginesOS_api
   end
end
