require_relative 'searchable'
require 'active_support/inflector'
require 'active_support/core_ext/string'

class AssocOptions
  attr_accessor(
    :class_name,
    :primary_key,
    :foreign_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.downcase.to_s + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @class_name = options[:class_name] ||= name.to_s.camelcase
    @primary_key = options[:primary_key] ||= :id
    @foreign_key = options[:foreign_key] ||= "#{name}_id".to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @class_name = options[:class_name] ||= name.to_s.singularize.camelcase
    @primary_key = options[:primary_key] ||= :id
    if self_class_name.class == Hash
      @foreign_key = options[:foreign_key] ||= self_class_name[:foreign_key]
    else
      @foreign_key = options[:foreign_key] ||= "#{self_class_name.downcase}_id".to_sym
    end
  end
end

module Associatable

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end

  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      key = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => key).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]

      key = self.send(options.primary_key)
      options.model_class.where(options.foreign_key => key)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      thr_options = self.class.assoc_options[through_name]
      src_options = thr_options.model_class.assoc_options[source_name]

      results = self.class.get_results(self, thr_options, src_options)
      src_options.model_class.parse_all(results).first
    end
  end

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
end

class SQLObject
  extend Associatable
end
