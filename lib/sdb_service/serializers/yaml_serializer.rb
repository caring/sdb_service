require 'sdb_service/serializer'
require 'yaml'

module SdbService
  class YamlSerializer < Serializer

    def serialize_payload(payload)
      YAML.dump(payload)
    end

    def deserialize_payload(payload)
      YAML.load(payload)
    end

  end
end