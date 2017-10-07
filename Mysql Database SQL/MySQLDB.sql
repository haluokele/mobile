-- Created by kAILE WEI
-- This is tht sql file for the assignment 2 of Mobile Computering.
-- In the project, we used mysql DBMS.
-- This project has two entities.
-- Entity User has 8 attributes and entity Task has 13 attributes.
-- The realtionship between User and Task is One-to-Many.

SET FOREIGN_KEY_CHECKS=0;
drop table if exists User;
drop table if exists Task;
SET FOREIGN_KEY_CHECKS=1;

Create TABLE User
(
   UserID INT(5) ZEROFILL NOT NULL AUTO_INCREMENT PRIMARY KEY,
   UserName VARCHAR (32) NOT NULL,
   RealName VARCHAR (32) NOT NULL,
   UserPW VARCHAR (32) NOT NULL,
   C1Name VARCHAR (32) NOT NULL,
   C1Email VARCHAR (32) NOT NULL,
   C2Name VARCHAR (32),
   C2Email VARCHAR (32)
);

-- (StartPointX, StartPointY) is the coordinate of start location.
-- (TerminalPointX, TerminalPointY) is the coordinate of terminal location.
-- (LastPointX, LastPointY) is the coordinate of the last update location.
-- "Canceled" is used to mark if the task is successfully canceled.

Create TABLE Task
(
   TaskID INT(6) ZEROFILL NOT NULL AUTO_INCREMENT PRIMARY KEY,
   StartTime INT(10) NOT NULL,
   EndTime INT(10) NOT NULL,
   StartPointX DOUBLE(10,6) NOT NULL,
   StartPointY DOUBLE(10,6) NOT NULL,
   TerminalPointX DOUBLE(10,6) NOT NULL,
   TerminalPointY DOUBLE(10,6) NOT NULL,
   LastPointX DOUBLE(10,6) NOT NULL,
   LastPointY DOUBLE(10,6) NOT NULL,
   LastUpdataTime INT(10) NOT NULL,
   Canceled CHAR(1) DEFAULT 'N' NOT NULL,
   UserID INT(5) ZEROFILL NOT NULL,
   CONSTRAINT FK_TaskUser FOREIGN KEY (UserID)
   REFERENCES User(UserID)
);
