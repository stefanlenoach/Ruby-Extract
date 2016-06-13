require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
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
    @foreign_key = options[:foreign_key] unless options[:foreign_key].nil?
    @class_name = options[:class_name] unless options[:class_name].nil?
    @primary_key = options[:primary_key] unless options[:primary_key].nil?

    @foreign_key ||= "#{name}_id".to_sym
    @class_name ||= name.camelize
    @primary_key ||= :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] unless options[:foreign_key].nil?
    @class_name = options[:class_name] unless options[:class_name].nil?
    @primary_key = options[:primary_key] unless options[:primary_key].nil?

    @foreign_key ||= "#{self_class_name.downcase}_id".to_sym
    @class_name ||= name.singularize.camelize
    @primary_key ||= :id
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
end
