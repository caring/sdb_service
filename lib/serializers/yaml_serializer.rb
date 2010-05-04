require 'serializers/serializer'
require 'yaml'

class YamlSerializer < Serializer
  
  def serialize_payload(payload)
    YAML.dump(payload)
  end
  
  def _deserialize_payload(payload)
    YAML.load(payload)
  end

end