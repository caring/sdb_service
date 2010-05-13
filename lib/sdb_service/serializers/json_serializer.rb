require 'sdb_service/serializer'
require 'json/pure'

module SdbService
  class JsonSerializer < Serializer
  
    def serialize_payload(payload)
      payload.is_a?(String) ? payload : JSON.generate(payload)
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