CREATE TABLE User
(
  Username VARCHAR(255) NOT NULL,
  Password VARCHAR(255) NOT NULL,
  Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Username)
);

CREATE TABLE Target_Depth
(
  Tdepth FLOAT NOT NULL,
  Target_Flume_Name INT NOT NULL,
  Tdate DATE NOT NULL,
  Username VARCHAR(255) NOT NULL,
  isComplete INT NOT NULL,
  PRIMARY KEY (Tdate),
  FOREIGN KEY (Username) REFERENCES User(Username)
);

CREATE TABLE Depth_Data
(
  Ddate DATE NOT NULL,
  Depth FLOAT NOT NULL,
  Depth_Flume_Name INT NOT NULL,
  PRIMARY KEY (Ddate)
);