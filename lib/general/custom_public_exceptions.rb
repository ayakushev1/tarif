module General
  class CustomPublicExceptions < ActionDispatch::PublicExceptions
    def call(env)
      status = env["PATH_INFO"][1..-1]
  
      if ["404", "422", "500"].include?(status)
        Rails.application.routes.call(env)
      else
        super
      end
    end
  end
end