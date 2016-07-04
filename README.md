# Ruby-Extract

## Object Relational Mapping

Uses Ruby to generate SQL query code and extract data from database via meta-programming.

## Demo Instructions

- Clone the repository. ```git clone https://github.com/stefanlenoach/Ruby-Extract.git```
- Navigate into the repository. ```cd Ruby-Extract```
- Configure the path in ```lib/db_connection``` to use your own database, or use ```turtles.sqlite``` as an example
- Create your own model or load ```demo.rb```

- Try a command
```
Turtle.where(owner_id: 1)
```
- Run methods on Turtles, Humans, and Houses
- Chain methods together to find exactly what you're looking for.
```
Turtle.find(1).human
Turtle.find(1).human.house
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
Turtle.all # => Returns an array of all Turtle objects
```
- ::find
```
Turtle.find(2) # => Finds Turtle object with id = 2
```
- ::where
```
Turtle.where(name: 'Garfield') #=> Finds Turtle object with name 'Garfield'
```
- #save
```
Turtle.new(name: "Biscuit", owner_id: 1).save #=> Creates or updates turtle and saves it to DB
```
- #belongs_to
```
Turtle.find(3).human #=> Finds Human associated with Turtle
```
- #has_many
```
Human.find(1).turtles #=> Finds turtles associated with human
```
- #has_one_through
```
Turtle.find(1).house #=> Finds House associated with Turtle through Human
```
