CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE turtles (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  turtles (id, name, owner_id)
VALUES
  (1, "Tyson", 1),
  (2, "Rocco", 2),
  (3, "Max", 2),
  (4, "Hotdog", 3),
  (5, "Goose", NULL);

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Frank", "Reynolds", 1),
  (2, "Dennis", "Reynolds", 2),
  (3, "Rickity", "Cricket", 3),
  (4, "Charlie", "Day", 4);

INSERT INTO
  houses (id, address)
VALUES
  (1, "711 Maple Street"),
  (2, "742 Evergreen Terrace"),
  (3, "Paddy's Pub, PA"),
  (4, "Paddy's Pub, PA");
