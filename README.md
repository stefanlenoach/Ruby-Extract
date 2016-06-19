# Ruby-Extract

## Object Relational Mapping

Uses Ruby to generate SQL query code and extract data from database via meta-programming.

## Demo Instructions

- Clone the repository.
- Navigate into the repository.
- Open irb or pry.
- Load the demo.rb file
```
load 'demo.rb'
```
- Try a command
```
Cat.where(owner_id: 1)
```
- Run methods on Cats, Humans, and Houses
- Chain methods together to find exactly what you're looking for.
```
Cat.find(1).human
Cat.find(1).human.house
```

- Use #methods to see all the Class and Object methods at your disposal
```
Human.methods
Human.find(1).methods
```

##  Features

- Relates SQL Object Classes to database tables.
- Prevents assignment of SQL Object Attributes which do not correspond to table columns.
- Extends SQL Object Class to allow Searching through "WHERE" clause.
- Allows SQL Object Classes to have Associations through foreign keys.

## Libraries and Gems
- ActiveSupport::Inflector
- SQLite3

## Methods Available
- ::all
```
Cat.all # => Returns an array of all Cat objects
```
- ::find
```
Cat.find(2) # => Finds Cat object with id = 2
```
- ::where
```
Cat.where(name: 'Garfield') #=> Finds Cat object with name 'Garfield'
```
- #save
```
Cat.new(name: "Biscuit", owner_id: 1).save #=> Creates or updates cat and saves it to DB
```
- #belongs_to
```
Cat.find(3).human #=> Finds Human associated with Cat
```
- #has_many
```
Human.find(1).cats #=> Finds cats associated with human
```
- #has_one_through
```
Cat.find(1).house #=> Finds House associated with Cat through Human
```
