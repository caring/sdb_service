module SdbService
  class Serializer
  
    def initialize(data)
      @payload = data
    end
  
    def serialize!
      serialize_payload(@payload) rescue @payload
    end
  
    def deserialize!
      deserialize_payload(@payload) rescue @payload
    end
  
    # these methods should be overriden by the strategy that subclasses the Serializer class.
  
    def serialize_payload
      raise "override me! -- #serialize_payload"
    end
  
    def deserialize_payload
      raise "override me! -- #deserialize_payload"
    end

  end
end