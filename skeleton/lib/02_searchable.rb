require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'

module Searchable
  def where(params)
    select_line = params.keys.map { |key| "#{key}" }.join(", ")
    where_line = params.keys.map { |key| "#{key} = ?"}.join(" AND ")
    query = "SELECT #{select_line} FROM #{self.table_name} WHERE #{where_line}"
    parse_all(DBConnection.execute(query, params.values))
  end
end

class SQLObject
  extend Searchable
end
