require 'sdb_service/serializer'
require 'json/pure'

module SdbService
  class JsonSerializer < Serializer
  
    def serialize_payload(payload)
      is_serializable?(payload) ? JSON.generate(payload) : payload 
    end
  
    def deserialize_payload(payload)
      begin
        return JSON.parse(payload)
      rescue JSON::ParserError
        return payload
      end
    end
    
    private
    
    def is_serializable?(payload)
      if payload.is_a?(String) || (payload.is_a?(Array) && !payload.find { |p| p.class != String })
        false
      else
        true
      end
    end
  
  end
end