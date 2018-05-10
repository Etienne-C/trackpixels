module Services
  class Locations
    require 'net/http'

    def self.lookup(ip)
      ip_address = ip

      url = "http://freegeoip.net/json/#{ip_address}"
      begin
        HTTParty.get(url, timeout: 2)
      rescue Timeout::Error
        Rails.logger.warn("Could not post to #{url}: timeout")
        {city: nil, region_name: nil}
      rescue
        Rails.logger.warn("Could not post to #{url}")
        {city: nil, region_name: nil}
      end
    end

  end
end
