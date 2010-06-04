require 'uuidtools'
require 'aws_sdb'
require 'sdb_service/support/constantizer'

module SdbService
    
  class Service
  
    include Constantizer
  
    attr_reader :database             # this is the name of the amazon SimpleDB domain.
    attr_reader :serializer_format    # this is a symbol representation of the serializer format.
  
    # initialization has one required argument, and one optional argument.
    # the first argument should be the name of the database on Amazon's SimpleDB servers.
    # the secondary, optional argument, is the type of serialization strategy you'd like
    # to use for this database.
    def initialize(database, serializer = :json)
      @serializer_format = serializer
      load_serializer!(@serializer_format)
      unless database.nil?
        @database = database
        self.class.create_database!(@database)
      end
    end
  
    # This method just takes a ruby object, of any depth or complexity; anything you
    # wish to send out to the Amazon SimpleDB service, can be sent there through this method.
    # eg: SERV.put("some" => "data", "more_data" => { "here" => [1,2,3] })
    #
    # all data passed through the #put method is serialized into whatever format you constructed
    # the data service to be aware of, however, you can pass a false in as the first argument of #put
    # to have it ignore serialization entirely.
    # eg: SERV.put(false, "some" => {"more" => [1,2,3]}) #=> { "some" => ["more123"]}
    #
    # put returns the unique identifier (UUID) of the object that was persisted into SimpleDB.
    def put(*args)
      data_payload, raw_payload = args
      serializer_result = nil
      if raw_payload.nil?
        data = _parse(data_payload) do |value|
          serializer_result = serializer.new(value)
          serializer_result.serialize!
        end
        data["mime_type"] = "text/#{self.serializer_format}"
      else
        data = raw_payload
        data["mime_type"] = "text/plain"
      end
    
      ident = self.class.generate_unique_identifier
      data_store.put_attributes(self.database, ident, data)
      return ident
    end
  
    # This method returns an object from Amazon SimpleDB based on its UUID identifier,
    # and will also attempt to deserialize its various values from whatever serialization
    # format you've specified when constructing the data service.
    def get(id)
      _parse(self.get!(id)) do |value|
        serializer.new(value.first).deserialize!
      end
    end
  
    # This method returns an object from Amazon SimpleDB based on its UUID identifier,
    # it returns the raw, unparsed data that sits at that key in the store.
    def get!(id)
      data_store.get_attributes(self.database, id)
    end
  
    # this method deletes an object from Amazon SimpleDB based on its UUID identifier.
    def delete(id)
      data_store.delete_attributes(self.database, id)
    end
  
    def query!(statement, limit = 30, token = nil)
      stmt = statement.nil? ? "" : statement
      data_store.query_with_attributes(self.database, stmt, limit, token)
    end
    
    # this method allows you to query simple for raw information using its query language.
    def query(statement, limit = 30, token = nil)
      response = Hash.new
      response['results'] = Hash.new
      query, token = self.query!(statement, limit, token)
      query.each do |item|
        response['results'][item[:name]] = item[:attributes]
      end
      response['token'] = token unless token.nil?
      return response
    end
  
    # this method returns all of the UUIDS stored in Amazon SimpleDB for the current domain.
    def all!
      self.query!(nil)
    end
  
    # this method returns all of the fully qualified, and deserialized objects stored in Amazon
    # SimpleDB for the current domain.
    def all
      self.query(nil)
    end
  
    # this method returns a list of all databases associated with this AWS account.
    def self.all_databases
      self.send(:data_store).list_domains[0]
    end
  
    # this method creates a new database associated with this AWS account, unless one with
    # the same name already exists. returns true on success, false on failure.
    def self.create_database!(database)
      unless self.all_databases.include?(database)
        self.send(:data_store).create_domain(database) 
        return true
      else
        return false
      end
    end
  
    # this method destroys an existing database associated with this AWS account, unless one
    # with the name specified does not exist. returns true on success, false on failure.
    def self.destroy_database!(database)
      if self.all_databases.include?(database)
        self.send(:data_store).delete_domain(database)
        return true
      else
        return false
      end
    end
  
    # this method can be used to reset all the data stored in an Amazon SimpleDB database associated
    # with the current AWS account.
    def clear!
      self.class.destroy_database!(self.database)
      self.class.create_database!(self.database)
    end

    private
  
    # simple method for associating and activiating a serializer strategy for an
    # instance of this class.
    def load_serializer!(serializer)
      @serializer = constantize("#{serializer}_serializer", "sdb_service/serializers")
    end
  
    # accessor for serializer
    def serializer
      @serializer
    end
  
    # simple strategy pattern that allows a block to have access to every value in a data hash
    # returned from Amazon SimpleDB. Useful for serialization/deserialization.
    def _parse(data, &block)
      Hash[data.collect { |k,v| [k,block.call(v)] }]
    end
  
    # accessor for AWS/SDB data service.
    def self.data_store
      AwsSdb::Service.new(:logger => Logger.new("/dev/null"))
    end
  
    # instance accessor for AWS/SDB data service.
    def data_store
      @store ||= self.class.data_store
    end
  
    # this helper method generates a random UUID for SimpleDB objects.
    def self.generate_unique_identifier
      UUIDTools::UUID.random_create.to_s
    end
  
  end
end