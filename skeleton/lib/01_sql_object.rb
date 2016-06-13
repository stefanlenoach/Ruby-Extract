require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    query = "SELECT * FROM #{table_name}"

    @result ||= DBConnection.execute2(query).first
    @result.map { |col_name| col_name.to_sym}
  end

  def self.finalize!
    self.columns.each do |name|

      define_method(name) do
        attributes[name]
      end

      define_method("#{name}=") do |arg|
        attributes[name] = arg
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
      return "#{self}".tableize if @table_name.nil?
      @table_name
  end

  def self.all
    query = "SELECT * FROM #{table_name}"
    result = DBConnection.execute(query)
    self.parse_all(result)
  end

  def self.parse_all(results)
    object = []
    results.each do |result|
      object << self.new(result)
    end
    object
  end

  def self.find(id)
    query = "SELECT * FROM #{table_name} WHERE id = #{id}"
    result = DBConnection.execute(query)
    return nil if result.empty?
    self.new(result.first)
  end

  def initialize(params = {})
    params.each do |key, value|
      raise "unknown attribute '#{key}'" unless self.class::columns.include?(key.to_sym)
      send("#{key}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    query = "SELECT * FROM #{self.class.table_name}"
    DBConnection.execute2(query).first.map do |col|
      send(col)
    end
  end

  def insert

    query = "SELECT * FROM #{self.class.table_name}"

    col_names = DBConnection.execute2(query).first
    questions = ['?'] * col_names.length
    col_names_joined = col_names.join(",")
    questions_joined = questions.join(",")
    vals = attribute_values

    new_query = "INSERT INTO #{self.class.table_name} (#{col_names_joined})
                  VALUES (#{questions_joined})"

    DBConnection.execute(new_query , *attribute_values)
    self.id = DBConnection.last_insert_row_id
  end

  def update
    query = "SELECT * FROM #{self.class.table_name}"
    col_names = DBConnection.execute2(query).first
    cols = col_names.map { |col| "#{col} = ?"}.join(", ")

    new_query = "UPDATE #{self.class.table_name} SET #{cols} WHERE id = #{self.id}"
    DBConnection.execute(new_query , *attribute_values)

  end

  def save
    return insert if self.id.nil?
    update
  end
end
