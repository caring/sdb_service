module SdbService
  class Serializer
  
    def initialize(data)
      @payload = data
      @transformed_payload = nil
      @valid = true
    end
  
    def serialize!
      begin
        @transformed_payload = serialize_payload(@payload)
        @valid = true
      rescue
        @valid = false
        @transformed_payload = @payload
      end
      return @transformed_payload
    end
  
    def deserialize!
      begin
        @transformed_payload = deserialize_payload(@payload) 
      rescue
        @transformed_payload = @payload
      end
      return @transformed_payload
    end
  
    def valid?
      @valid
    end
    
    def to_s
      @transformed_payload
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