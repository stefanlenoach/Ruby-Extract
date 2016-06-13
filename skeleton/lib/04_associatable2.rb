require_relative '03_associatable'

module Associatable

  def get_results(obj, thr_options, src_options)
    key_val = obj.send(thr_options.foreign_key)
    return DBConnection.execute(<<-SQL, key_val)
      SELECT
        #{src_options.table_name}.*
      FROM
        #{thr_options.table_name}
      JOIN
        #{src_options.table_name}
      ON
        #{thr_options.table_name}.#{src_options.foreign_key} = #{src_options.table_name}.#{src_options.primary_key}
      WHERE
        #{thr_options.table_name}.#{thr_options.primary_key} = ?
    SQL
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      thr_options = self.class.assoc_options[through_name]
      src_options = thr_options.model_class.assoc_options[source_name]
      
      results = self.class.get_results(self, thr_options, src_options)
      src_options.model_class.parse_all(results).first
    end
  end
end
