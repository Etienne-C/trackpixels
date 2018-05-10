module Services
  class Params
    require 'active_support/all'

    def self.deploy(obj)
      @url_obj = obj
      if obj.class == ActionController::Parameters
        return_new_hash @url_obj
      else
        check_for_decode
      end
    end

    def self.check_for_decode
      if is_base_64 @url_obj
        str = decode(@url_obj)
        return_params(str)
      else
        return_params @url_obj
      end
    end

    def self.return_new_hash(hash)
      hash[:campaign] = hash.delete(:track)
      campaign = hash[:campaign].split(/=/)
      hash[:campaign] = campaign[1]
      hash
    end

    def self.return_params(str)
      arry  = str.split(/&/)
      hash = {}
      if arry.length <= 1
        raise ActionController::RoutingError.new('Not Found')
      else
        arry.each{|a| hash[a.scan(/^\w*/).join('').to_sym] = a.gsub(/^(\w*=)/,'')}
      end
      hash
    end

    def self.decode(str)
      str = Base64.urlsafe_decode64(str)
    end

    def self.is_base_64(str)
      str =~ /^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{4}|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)$/
    end

  end
end
