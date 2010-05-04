require 'rubygems'
require 'uuidtools'
require 'aws_sdb'
require 'constantizer'

class SimpleDataService
  
  include Constantizer
  
  attr_reader :database
  
  def initialize(database = nil, serializer = :json)
    load_serializer!(serializer)
    unless database.nil?
      @database = database 
      self.class.create_database!(@database)
    end
  end
  
  def all
    self.query("")
  end
  
  def all!
    results = Hash.new
    self.all[0].each do |item_name|
      results[item_name] = self.get(item_name)
    end
    return results
  end
  
  def query(statement)
    data_store.query(self.database, statement)
  end
  
  def put(*args)
    data_payload, raw_payload = args
    data = raw_payload.nil? ? _parse(data_payload) { |value| serializer.new(value).serialize! } : raw_payload
    ident = self.class.generate_unique_identifier
    data_store.put_attributes(self.database, ident, data)
    return ident
  end
  
  def get(id)
    _parse(self.get!(id)) do |value|
      serializer.new(value.first).deserialize!
    end
  end
  
  def get!(id)
    data_store.get_attributes(self.database, id)
  end
  
  def delete(id)
    data_store.delete_attributes(self.database, id)
  end
  
  def self.all_databases
    self.send(:data_store).list_domains[0]
  end
  
  def self.create_database!(database)
    unless self.all_databases.include?(database)
      self.send(:data_store).create_domain(database) 
      return true
    else
      return false
    end
  end
  
  def self.destroy_database!(database)
    if self.all_databases.include?(database)
      self.send(:data_store).delete_domain(database)
      return true
    else
      return false
    end
  end
  
  def clear!
    self.class.destroy_database!(self.database)
    self.class.create_database!(self.database)
  end

  private
  
  def load_serializer!(serializer)
    @serializer = constantize("#{serializer}_serializer", "lib/serializers")
  end
  
  def serializer
    @serializer
  end
  
  def _parse(data, &block)
    Hash[data.collect { |k,v| [k,block.call(v)] }]
  end
  
  def self.data_store
    AwsSdb::Service.new
  end
  
  def data_store
    @store ||= self.class.data_store
  end
  
  def self.generate_unique_identifier
    UUIDTools::UUID.random_create.to_s
  end
  
end