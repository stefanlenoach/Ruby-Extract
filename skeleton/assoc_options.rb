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
