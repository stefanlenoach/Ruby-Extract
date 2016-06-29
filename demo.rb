require './lib/associatable'

class Turtle < SQLObject
  self.table_name = "turtles"

  belongs_to :human, foreign_key: :owner_id
  has_one_through :house, :human, :house

  self.finalize!
end

class Human < SQLObject
  self.table_name = "humans"

  belongs_to :house
  has_many :turtles, foreign_key: :owner_id

  self.finalize!
end

class House < SQLObject
  has_many :humans,
    class_name: "Humans",
    foreign_key: :house_id,
    primary_key: :id

  self.finalize!
end
