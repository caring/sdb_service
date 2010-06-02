require 'sdb_service/serializer'

unless defined? JSON
  require 'json/pure'
end

module SdbService
  class JsonSerializer < Serializer
  
    def serialize_payload(payload)
      if payload.is_a?(String)
        return payload
      else
        payload.respond_to?(:to_json) ? payload.to_json : JSON.dump(payload)
      end
    end
  
    def deserialize_payload(payload)
      begin
        return JSON.parse(payload)
      rescue JSON::ParserError
        return payload
      end
    end
  
  end
end