require_relative '02_searchable'
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
    defaults = {
      class_name:  name.to_s.camelcase,
      primary_key: :id,
      foreign_key: "#{name}_id".to_sym
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      class_name: name.singularize.camelize,
      primary_key: :id,
      foreign_key: "#{self_class_name.downcase}_id".to_sym
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end

  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      key = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => key).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, options)
    define_method(name) do
      debugger
      key = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => key).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  extend Associatable
end
