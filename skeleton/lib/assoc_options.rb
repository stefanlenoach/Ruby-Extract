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
      class_name: name.to_s.singularize.camelize,
      primary_key: :id,
      foreign_key: "#{self_class_name.to_s.downcase}_id".to_sym
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end

  end
end
