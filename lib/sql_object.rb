require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @columns if @columns

    query = "SELECT * FROM #{ table_name }"

    cols = DBConnection.execute2(query).first
    @columns = cols.map { |col_name| col_name.to_sym}
  end

  def self.finalize!
    self.columns.each do |name|
      define_method(name) do
        attributes[name]
      end

      define_method("#{ name }=") do |arg|
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
    query = "SELECT * FROM #{ table_name }"
    results = DBConnection.execute(query)

    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    query = "SELECT * FROM #{ table_name } WHERE id = #{ id }"
    result = DBConnection.execute(query)

    return nil if result.empty?
    self.new(result.first)
  end

  def initialize(params = {})
    params.each do |key, value|
      raise "unknown attribute '#{ key }'" unless self.class::columns.include?(key.to_sym)
      send("#{ key }=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |col| send(col) }
  end

  def save
    self.id.nil? ? insert : update
  end

  private

  def insert
    columns = self.class.columns.drop(1)
    col_names = columns.map(&:to_s).join(",")
    questions = (['?'] * columns.length).join(",")

    query = "INSERT INTO #{ self.class.table_name } (#{ col_names }) VALUES (#{ questions })"

    DBConnection.execute(query , *attribute_values.drop(1))
    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns.map { |col| "#{ col } = ?" }.join(", ")

    new_query = "UPDATE #{ self.class.table_name } SET #{ cols } WHERE id = #{ self.id }"
    DBConnection.execute(new_query , *attribute_values)
  end
end
