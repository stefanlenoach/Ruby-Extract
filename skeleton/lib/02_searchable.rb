require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?"}.join(" AND ")
    query = "SELECT * FROM #{self.table_name} WHERE #{where_line}"
    
    parse_all(DBConnection.execute(query, params.values))
  end
end

class SQLObject
  extend Searchable
end
