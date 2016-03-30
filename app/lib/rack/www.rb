module Rack
  class Www
    def initialize(app)
      @app = app
    end
    def call(env)
      if (env['SERVER_NAME'] =~ /^www\./) or (env['SERVER_NAME'] == '46.101.146.117')
        @app.call(env)
      else
        [ 301, { 'Location' => 'http://www.mytarifs.ru/' }, '' ]
      end
    end
  end
end