require 'serializers/serializer'
require 'json/pure'

class JsonSerializer < Serializer
  
  def serialize_payload(payload)
    JSON.generate(payload)
  end
  
  def deserialize_payload(payload)
    JSON.parse(payload)
  end
  
end