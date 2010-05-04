require 'sdb_service/serializer'
require 'json/pure'

module SdbService
  class JsonSerializer < Serializer
  
    def serialize_payload(payload)
      JSON.generate(payload)
    end
  
    def deserialize_payload(payload)
      JSON.parse(payload)
    end
  
  end
end