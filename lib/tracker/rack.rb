module Tracker
  class Rack

    def initialize(app)
      @app = app
    end

    def call(env)
      @req = ::Rack::Request.new(env)
      if @req.path_info =~ /tracker.png/
        result = Services::Params.deploy @req.query_string
        location = Services::Locations.lookup(@req.ip)
        ip_address = location["ip"] || @req.ip
        params = {
          ip_address:     ip_address,
          campaign:       result[:campaign],
          banner_size:    result[:banner_size],
          content_type:   result[:content_type],
          city:           location["city"],
          state:          location["region_name"],
          user_agent:     @req.user_agent,
          referral:       @req.referer
        }

        if @pixels = Pixel.create!(params)
          [
            200, { 'Content-Type' => 'image/png' },
            [File.read(File.join(File.dirname(__FILE__), 'tracker.png'))]
          ]
        else
          Rails.logger.warn "\n\n Failed to create record on:#{Date.today}"
        end
      else
        @app.call(env)
      end
    end

  end
end
