require_relative '03_associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      thr_options = self.class.assoc_options[through_name]
      src_options = thr_options.model_class.assoc_options[source_name]

      thr_table = thr_options.table_name
      thr_pk = thr_options.primary_key
      thr_fk = thr_options.foreign_key

      src_table = src_options.table_name
      src_pk = src_options.primary_key
      src_fk = src_options.foreign_key

      key_val = self.send(thr_fk)
      results = DBConnection.execute(<<-SQL, key_val)
        SELECT
          #{src_table}.*
        FROM
          #{thr_table}
        JOIN
          #{src_table}
        ON
          #{thr_table}.#{src_fk} = #{src_table}.#{src_pk}
        WHERE
          #{thr_table}.#{through_pk} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end
end
