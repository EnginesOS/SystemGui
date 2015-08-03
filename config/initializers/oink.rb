
Rails.application.middleware.use( Oink::Middleware, :instruments => [:activerecord, :memory] )