require 'sdb_service/serializer'
require 'json/pure'

module SdbService
  class JsonSerializer < Serializer
  
    def serialize_payload(payload)
      payload.is_a?(String) ? payload : JSON.generate(payload)
    end
  
    def deserialize_payload(payload)
      payload.is_a?(String) ? payload : JSON.parse(payload)
    end
  
  end
end