class Serializer
  
  def initialize(data)
    @payload = data
    @transformed_payload = nil
  end
  
  def serialize!
    @transformed_payload = serialize_payload(@payload)
  end
  
  def deserialize!
    @transformed_payload = deserialize_payload(@payload) rescue @payload
  end
  
  def to_s
    @transformed_payload
  end
  
  def serialize_payload
    raise "override me! -- #serialize_payload"
  end
  
  def deserialize_payload
    raise "override me! -- #deserialize_payload"
  end

end