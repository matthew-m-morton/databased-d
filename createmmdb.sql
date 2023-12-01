-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mmdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mmdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mmdb` DEFAULT CHARACTER SET utf8 ;
USE `mmdb` ;

-- -----------------------------------------------------
-- Table `mmdb`.`movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`movie` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`movie` (
  `movie_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `release_year` YEAR NOT NULL,
  `length` SMALLINT NOT NULL,
  `rating` ENUM('G', 'PG', 'PG-13', 'R', 'NC-17') NOT NULL,
  PRIMARY KEY (`movie_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`actor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`actor` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`actor` (
  `actor_id` INT NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  PRIMARY KEY (`actor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`series`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`series` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`series` (
  `series_id` INT NOT NULL AUTO_INCREMENT,
  `series_name` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `rating` ENUM('TV-Y', 'TV-Y7', 'TV-Y7 FV', 'TV-G', 'TV-PG', 'TV-14', 'TV-MA') NOT NULL,
  PRIMARY KEY (`series_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`account` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`account` (
  `account_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  PRIMARY KEY (`account_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`profile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`profile` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`profile` (
  `profile_id` INT NOT NULL,
  `account_id` INT NOT NULL,
  `profile_name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`profile_id`, `account_id`),
  INDEX `fk_profile_account1_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `fk_profile_account1`
    FOREIGN KEY (`account_id`)
    REFERENCES `mmdb`.`account` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`queue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`queue`;

CREATE TABLE IF NOT EXISTS `mmdb`.`queue` (
  `profile_id` INT NOT NULL,
  `movie_id` INT NULL, 
  `series_id` INT NULL, 
  INDEX `fk_queue_movie1_idx` (`movie_id` ASC) VISIBLE,
  INDEX `fk_queue_series1_idx` (`series_id` ASC) VISIBLE,
  CONSTRAINT `fk_queue_profile1`
    FOREIGN KEY (`profile_id`)
    REFERENCES `mmdb`.`profile` (`profile_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_queue_movie1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mmdb`.`movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_queue_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mmdb`.`movie_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`movie_history` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`movie_history` (
  `watchhistory_id` INT NOT NULL,
  `profile_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  PRIMARY KEY (`watchhistory_id`, `profile_id`, `movie_id`),
  INDEX `fk_watchhistory_profile1_idx` (`profile_id` ASC) VISIBLE,
  INDEX `fk_watchhistory_movie1_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_watchhistory_profile1`
    FOREIGN KEY (`profile_id`)
    REFERENCES `mmdb`.`profile` (`profile_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_watchhistory_movie1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mmdb`.`movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`episodes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`episodes` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`episodes` (
  `episodes_id` INT NOT NULL AUTO_INCREMENT,
  `series_id` INT NOT NULL,
  `episode_name` VARCHAR(100) NOT NULL,
  `length` INT NULL,
  `season_num` INT NOT NULL,
  `episode_num` INT NOT NULL,
  PRIMARY KEY (`episodes_id`, `series_id`),
  INDEX `fk_episodes_series1_idx` (`series_id` ASC) VISIBLE,
  CONSTRAINT `fk_episodes_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`series_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`series_history` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`series_history` (
  `profile_id` INT NOT NULL,
  `episodes_id` INT NOT NULL,
  `series_id` INT NOT NULL,
  PRIMARY KEY (`profile_id`, `episodes_id`, `series_id`),
  INDEX `fk_profile_has_episodes_episodes1_idx` (`episodes_id` ASC) VISIBLE,
  INDEX `fk_profile_has_episodes_profile1_idx` (`profile_id` ASC) VISIBLE,
  INDEX `fk_series_history_series1_idx` (`series_id` ASC) VISIBLE,
  CONSTRAINT `fk_profile_has_episodes_profile1`
    FOREIGN KEY (`profile_id`)
    REFERENCES `mmdb`.`profile` (`profile_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_profile_has_episodes_episodes1`
    FOREIGN KEY (`episodes_id`)
    REFERENCES `mmdb`.`episodes` (`episodes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_series_history_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`movie_cast`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`movie_cast` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`movie_cast` (
  `movie_id` INT NOT NULL,
  `actor_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `actor_id`),
  INDEX `fk_movie_has_actor_actor1_idx` (`actor_id` ASC) VISIBLE,
  INDEX `fk_movie_has_actor_movie1_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_movie_has_actor_movie1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mmdb`.`movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_movie_has_actor_actor1`
    FOREIGN KEY (`actor_id`)
    REFERENCES `mmdb`.`actor` (`actor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`series_cast`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`series_cast` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`series_cast` (
  `series_id` INT NOT NULL,
  `actor_id` INT NOT NULL,
  PRIMARY KEY (`series_id`, `actor_id`),
  INDEX `fk_episodes_has_actor_actor1_idx` (`actor_id` ASC) VISIBLE,
  INDEX `fk_episode_cast_series1_idx` (`series_id` ASC) VISIBLE,
  CONSTRAINT `fk_episodes_has_actor_actor1`
    FOREIGN KEY (`actor_id`)
    REFERENCES `mmdb`.`actor` (`actor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_episode_cast_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`genre` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`genre` (
  `genre_id` INT NOT NULL,
  `genre` VARCHAR(45) NULL,
  PRIMARY KEY (`genre_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`movie_genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`movie_genre` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`movie_genre` (
  `movie_id` INT NOT NULL,
  `genre_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `genre_id`),
  INDEX `fk_movie_has_genre_genre1_idx` (`genre_id` ASC) VISIBLE,
  INDEX `fk_movie_has_genre_movie1_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_movie_has_genre_movie1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mmdb`.`movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_movie_has_genre_genre1`
    FOREIGN KEY (`genre_id`)
    REFERENCES `mmdb`.`genre` (`genre_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`series_genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`series_genre` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`series_genre` (
  `series_id` INT NOT NULL,
  `genre_id` INT NOT NULL,
  PRIMARY KEY (`series_id`, `genre_id`),
  INDEX `fk_series_has_genre_genre1_idx` (`genre_id` ASC) VISIBLE,
  INDEX `fk_series_has_genre_series1_idx` (`series_id` ASC) VISIBLE,
  CONSTRAINT `fk_series_has_genre_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_series_has_genre_genre1`
    FOREIGN KEY (`genre_id`)
    REFERENCES `mmdb`.`genre` (`genre_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`studio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`studio` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`studio` (
  `studio_id` INT NOT NULL AUTO_INCREMENT,
  `studio_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`studio_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`series_studio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`series_studio` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`series_studio` (
  `series_id` INT NOT NULL,
  `studio_id` INT NOT NULL,
  PRIMARY KEY (`series_id`, `studio_id`),
  INDEX `fk_series_has_studio_studio1_idx` (`studio_id` ASC) VISIBLE,
  INDEX `fk_series_has_studio_series1_idx` (`series_id` ASC) VISIBLE,
  CONSTRAINT `fk_series_has_studio_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_series_has_studio_studio1`
    FOREIGN KEY (`studio_id`)
    REFERENCES `mmdb`.`studio` (`studio_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`movie_studio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`movie_studio` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`movie_studio` (
  `movie_id` INT NOT NULL,
  `studio_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `studio_id`),
  INDEX `fk_studio_has_movie_movie1_idx` (`movie_id` ASC) VISIBLE,
  INDEX `fk_studio_has_movie_studio1_idx` (`studio_id` ASC) VISIBLE,
  CONSTRAINT `fk_studio_has_movie_studio1`
    FOREIGN KEY (`studio_id`)
    REFERENCES `mmdb`.`studio` (`studio_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_studio_has_movie_movie1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mmdb`.`movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`director`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`director` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`director` (
  `director_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`director_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`series_director`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`series_director` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`series_director` (
  `series_id` INT NOT NULL,
  `director_id` INT NOT NULL,
  PRIMARY KEY (`series_id`, `director_id`),
  INDEX `fk_episodes_has_director_director1_idx` (`director_id` ASC) VISIBLE,
  INDEX `fk_episode_director_series1_idx` (`series_id` ASC) VISIBLE,
  CONSTRAINT `fk_episodes_has_director_director1`
    FOREIGN KEY (`director_id`)
    REFERENCES `mmdb`.`director` (`director_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_episode_director_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`movie_director`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`movie_director` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`movie_director` (
  `movie_id` INT NOT NULL,
  `director_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `director_id`),
  INDEX `fk_movie_has_director_director1_idx` (`director_id` ASC) VISIBLE,
  INDEX `fk_movie_has_director_movie1_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_movie_has_director_movie1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mmdb`.`movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_movie_has_director_director1`
    FOREIGN KEY (`director_id`)
    REFERENCES `mmdb`.`director` (`director_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`review_score_series`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`review_score_series` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`review_score_series` (
  `review_score_series_id` INT NOT NULL,
  `score` DECIMAL(2,1) NOT NULL,
  `series_id` INT NOT NULL,
  `profile_id` INT NOT NULL,
  PRIMARY KEY (`review_score_series_id`, `series_id`, `profile_id`),
  INDEX `fk_review_score_series_series1_idx` (`series_id` ASC) VISIBLE,
  INDEX `fk_review_score_series_profile1_idx` (`profile_id` ASC) VISIBLE,
  CONSTRAINT `fk_review_score_series_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `mmdb`.`series` (`series_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_score_series_profile1`
    FOREIGN KEY (`profile_id`)
    REFERENCES `mmdb`.`profile` (`profile_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mmdb`.`review_score_movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mmdb`.`review_score_movie` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`review_score_movie` (
  `review_score_movie_id` INT NOT NULL,
  `score` DECIMAL(2,1) NOT NULL,
  `movie_id` INT NOT NULL,
  `profile_id` INT NOT NULL,
  PRIMARY KEY (`review_score_movie_id`, `movie_id`, `profile_id`),
  INDEX `fk_review_score_movie_movie1_idx` (`movie_id` ASC) VISIBLE,
  INDEX `fk_review_score_movie_profile1_idx` (`profile_id` ASC) VISIBLE,
  CONSTRAINT `fk_review_score_movie_movie1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mmdb`.`movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_score_movie_profile1`
    FOREIGN KEY (`profile_id`)
    REFERENCES `mmdb`.`profile` (`profile_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;






-- INSERT STATEMENTS
-- POPULATE ACCOUNT TABLE


-- POPULATE ACTOR TABLE

INSERT INTO actor
(actor_id, first_name, last_name)
VALUES
('1', 'Justin', 'Roiland'),
('2', 'Chris', 'Parnell'),
('3', 'Spencer', 'Grammer'),
('4', 'Sarah', 'Chalke'),
('5', 'Jason', 'Ritter'),
('6', 'Kristen', 'Schaal'),
('7', 'Alex', 'Hirsch'),
('8', 'Linda', 'Cardellini'),
('9', 'Bryan', 'Cranston'),
('10', 'Aaron', 'Paul'),
('11', 'Anna', 'Gunn'),
('12', 'Dean', 'Norris'),
('13', 'Bob', 'Odenkirk'),
('14', 'Jonathan', 'Banks'),
('15', 'Rhea', 'Seehorn'),
('16', 'Patrick', 'Fabian'),
('17', 'Jason', 'Lee'),
('18', 'Ethan', 'Suplee'),
('19', 'Jaime', 'Pressly'),
('20', 'Nadine', 'Velazquez'),
('21', 'Daniel', 'Craig'),
('22', 'Rami', 'Malek'),
('23', 'Lashana', 'Lynch'),
('24', 'Lea', 'Seydoux'),
('25', 'Ryan', 'Reynolds'),
('26', 'Jodie', 'Comer'),
('27', 'Joe', 'Keery'),
('28', 'aika', 'Waititi'),
('29', 'Sam', 'Rockwell'),
('30', 'Richard', 'Ayoade'),
('31', 'Anthony', 'Ramos'),
('32', 'Zazie', 'Beetz'),
('33', 'Tom', 'Cruise'),
('34', 'Val', 'Kilmer'),
('35', 'Kelly', 'McGillis'),
('36', 'Anthony', 'Edwards'),
('37', 'Miles', 'Teller'),
('38', 'Glen', 'Powell'),
('39', 'Daisy Edgar', 'Jones'),
('40', 'Taylor John', 'Smith'),
('41', 'Harris', 'Dickinson'),
('42', 'David', 'Strathairn'),
('43', 'Roy', 'Schneider'),
('44', 'Richard', 'Dreyfuss'),
('45', 'Robert', 'Shaw'),
('46', 'Lorraine', 'Gary'),
('47', 'Bill', 'Skarsgard'),
('48', 'Justin', 'Long'),
('49', 'Georgina', 'Campbell'),
('50', 'Zach', 'Creggor'),
('51', 'Mia', 'Goth'),
('52', 'David', 'Corensweet'),
('53', 'Alistair', 'Sewell'),
('54', 'Matthew', 'Sunderland'),
('55', 'Tom', 'Holland'),
('56', 'Tobey', 'Maguire'),
('57', 'Andrew', 'Garfield'),
('58', 'Marisa', 'Tomei'),
('59', 'Madelyn', 'Cline'),
('60', 'Kate', 'Hudson'),
('61', 'Edward', 'Norton'),
('62', 'Aaron-Taylor', 'Johnson'),
('63', 'Brad', 'Pitt'),
('64', 'Joey', 'King'),
('65', 'Bad', 'Bunny'),
('66', 'Stanley', 'Tucci'),
('67', 'Gemma', 'Arterton'),
('68', 'Ralph', 'Fiennes'),
('69', 'Timothee', 'Chalamet'),
('70', 'Rebecca', 'Ferguson'),
('71', 'Zendaya', 'Coleman'),
('72', 'Oscar', 'Isaac'),
('73', 'Kenneth', 'Branagh'),
('74', 'Armie', 'Hammer'),
('75', 'Gal', 'Gadot'),
('76', 'Annette', 'Bening'),
('77', 'Sophia', 'Ali'),
('78', 'Mark', 'Wahlberg'),
('79', 'Tati', 'Gabrielle'),
('80', 'Robert', 'Pattinson'),
('81', 'Zoe', 'Kravitz'),
('82', 'Paul', 'Dano'),
('83', 'Colin', 'Farrell'),
('84', 'Sam', 'Worthington'),
('85', 'Zoe', 'Saldana'),
('86', 'Sigourney', 'Weaver'),
('87', 'Kate', 'Winslet'),
('88', 'Antonio', 'Banderas'),
('89', 'Salma', 'Hayek'),
('90', 'Florence', 'Pugh'),
('91', 'Harvey', 'Guillen'),
('92', 'Jim', 'Carrey'),
('93', 'Ben', 'Schwartz'),
('94', 'Tika', 'Sumpter'),
('95', 'James', 'Marsden');

-- POPULATE STUDIO TABLE

INSERT INTO studio
(studio_id, studio_name)
VALUES
('1', 'AMC'),
('2', '20th Century Fox'),
('3', 'Adult Swim'),
('4', 'Disney Channel'),
('5', 'Metro Goldwyn Mayer'),
('6', 'Dreamworks'),
('7', 'Paramount'),
('8', 'Skydance'),
('9', '3000 Pictures'),
('10', 'Hello Sunshine Productions'),
('11', 'Universal Pictures'),
('12', 'Hammerstone Studios'),
('13', 'A24'),
('14', 'Marvel Studios'),
('15', 'T-Street Productions'),
('16', 'Columbia Pictures'),
('17', 'Legendary Pictures'),
('18', 'Playstation Productions'),
('19', 'Warner Bros Pictures'),
('20', 'DC Films'),
('21', 'Lightstorm Entertainment'),
('22', 'Sega');

-- POPULATE DIRECTOR TABLE

INSERT INTO director
(director_id, first_name, last_name)
VALUES
('1', 'Vince', 'Gilligan'),
('2', 'Greg', 'Garcia'),
('3', 'Dan', 'Harmon'),
('4', 'Alex', 'Hirsch'),
('5', 'Cary Joji', 'Fukunaga'),
('6', 'Shawn', 'Levy'),
('7', 'Pierre', 'Perifel'),
('8', 'Tony', 'Scott'),
('9', 'Joseph', 'Kosinski'),
('10', 'Olivia', 'Newman'),
('11', 'Steven', 'Spielberg'),
('12', 'Zach', 'Creggor'),
('13', 'Ti', 'West'),
('14', 'Jon', 'Watts'),
('15', 'Rian', 'Johnson'),
('16', 'David', 'Leitch'),
('17', 'Matthew', 'Vaughn'),
('18', 'Denis', 'Villeneuve'),
('19', 'Kenneth', 'Branagh'),
('20', 'Ruben', 'Fleischer'),
('21', 'Matt', 'Reeves'),
('22', 'James', 'Cameron'),
('23', 'Joel', 'Crawford'),
('24', 'Jeff', 'Fowler');

-- POPULATE SERIES TABLE

INSERT INTO series
(series_id, series_name, description, rating)
VALUES
('1', 'Rick and Morty', 'An animated series that follows the exploits of a super scientist and his not-so-bright grandson.', 'TV-MA'),
('2', 'Gravity Falls', '\"Gravity Falls\" is an animated mystery-adventure series about twins unraveling supernatural secrets in a quirky town.', 'TV-Y7'),
('3', 'Breaking Bad', '\"Breaking Bad\" follows a high school teacher-turned-drug dealer\'s transformation in an intense crime drama.', 'TV-MA'),
('4', 'Better call Saul', '\"Better Call Saul\" explores the transformation of a small-time lawyer into a morally flexible attorney in a \"Breaking Bad\" prequel.', 'TV-MA'),
('5', 'My name is Earl', 'a TV comedy where a reformed criminal seeks redemption by helping those he\'s wronged.', 'TV-14');

-- POPULATE EPISODE TABLE

INSERT INTO episodes
(episodes_id, series_id, episode_name, length, season_num, episode_num)
VALUES
('1', '1', 'Pilot', '22', '1', '1'),
('2', '1', 'Lawnmower Dog', '22', '1', '2'),
('3', '1', 'Anatomy Park', '22', '1', '3'),
('4', '1', 'M. Night Shaym-Aliens!', '22', '1', '4'),
('5', '1', 'Meeseeks and Destroy', '22', '1', '5'),
('6', '1', 'Rick Potion #9', '22', '1', '6'),
('7', '1', 'Raising Gazorpazorp', '22', '1', '7'),
('8', '1', 'Rixty Minutes', '22', '1', '8'),
('9', '1', 'Something Ricked This Way Comes', '22', '1', '9'),
('10', '1', 'Close Rick-Counters of the Rick Kind', '22', '1', '10'),
('11', '1', 'Ricksy Business', '22', '1', '11'),
('12', '1', 'A Rickle in Time', '22', '2', '12'),
('13', '1', 'Mortynight Run', '22', '2', '13'),
('14', '1', 'Auto Erotic Assimilation', '22', '2', '14'),
('15', '1', 'Total Rickall', '22', '2', '15'),
('16', '1', 'Get Schwifty', '22', '2', '16'),
('17', '1', 'The Ricks Must Be Crazy', '22', '2', '17'),
('18', '1', 'Big Trouble in Little Sanchez', '22', '2', '18'),
('19', '1', 'Interdimensional Cable 2: Tempting Fate', '22', '2', '19'),
('20', '1', 'Look Who\'s Purging Now', '22', '2', '20'),
('21', '1', 'The Wedding Squanchers', '22', '2', '21'),
('22', '1', 'The Rickshank Rickdemption', '22', '3', '22'),
('23', '1', 'Rickmancing the Stone', '22', '3', '23'),
('24', '1', 'Pickle Rick', '22', '3', '24'),
('25', '1', 'Vindicators 3: The Return of Worldender', '22', '3', '25'),
('26', '1', 'The Whirly Dirly Conspiracy', '22', '3', '26'),
('27', '1', 'Rest and Ricklaxation', '22', '3', '27'),
('28', '1', 'The Ricklantis Mixup', '22', '3', '28'),
('29', '1', 'Morty\'s Mind Blowers', '22', '3', '29'),
('30', '1', 'The ABC\'s of Beth', '22', '3', '30'),
('31', '1', 'The Rickchurian Mortydate', '22', '3', '31'),
('32', '1', 'Edge of Tomorty: Rick Die Rickpeat', '22', '4', '32'),
('33', '1', 'The Old Man and the Seat', '22', '4', '33'),
('34', '1', 'One Crew Over the Crewcoo\'s Morty', '22', '4', '34'),
('35', '1', 'Claw and Hoarder: Special Ricktim\'s Morty', '22', '4', '35'),
('36', '1', 'Rattlestar Ricklactica', '22', '4', '36'),
('37', '1', 'Never Ricking Morty', '22', '4', '37'),
('38', '1', 'Promortyus', '22', '4', '38'),
('39', '1', 'The Vat of Acid Episode', '22', '4', '39'),
('40', '1', 'Childrick of Mort', '22', '4', '40'),
('41', '1', 'Star Mort Rickturn of the Jerri', '22', '4', '41'),
('42', '1', 'Mort Dinner Rick Andre', '22', '5', '42'),
('43', '1', 'Mortyplicity', '22', '5', '43'),
('44', '1', 'A Rickconvenient Mort', '22', '5', '44'),
('45', '1', 'Rickdependence Spray', '22', '5', '45'),
('46', '1', 'Amortycan Grickfitti', '22', '5', '46'),
('47', '1', 'Rick & Morty\'s Thanksploitation Spectacular', '22', '5', '47'),
('48', '1', 'Gotron Jerrysis Rickvangelion', '22', '5', '48'),
('49', '1', 'Rickternal Friendshine of the Spotless Mort', '22', '5', '49'),
('50', '1', 'Forgetting Sarick Mortshall', '22', '5', '50'),
('51', '1', 'Rickmurai Jack', '22', '5', '51'),
('52', '2', 'Tourist Trapped', '22', '1', '1'),
('53', '2', 'The Legend of the Gobblewonker', '22', '1', '2'),
('54', '2', 'Headhunters', '22', '1', '3'),
('55', '2', 'The Hand That Rocks the Mabel', '22', '1', '4'),
('56', '2', 'The Inconveniencing', '22', '1', '5'),
('57', '2', 'Dipper vs. Manliness', '22', '1', '6'),
('58', '2', 'Double Dipper', '22', '1', '7'),
('59', '2', 'Irrational Treasure', '22', '1', '8'),
('60', '2', 'The Time Traveler\'s Pig', '22', '1', '9'),
('61', '2', 'Fight Fighters', '22', '1', '10'),
('62', '2', 'Little Dipper', '22', '1', '11'),
('63', '2', 'Summerween', '22', '1', '12'),
('64', '2', 'Boss Mabel', '22', '1', '13'),
('65', '2', 'Bottomless Pit!', '22', '1', '14'),
('66', '2', 'The Deep End', '22', '1', '15'),
('67', '2', 'Carpet Diem', '22', '1', '16'),
('68', '2', 'Boyz Crazy', '22', '1', '17'),
('69', '2', 'Land Before Swine', '22', '1', '18'),
('70', '2', 'Dreamscaperers', '22', '1', '19'),
('71', '2', 'Gideon Rises', '22', '1', '20'),
('72', '2', 'Scary-oke', '22', '2', '21'),
('73', '2', 'Into the Bunker', '22', '2', '22'),
('74', '2', 'The Golf War', '22', '2', '23'),
('75', '2', 'Sock Opera', '22', '2', '24'),
('76', '2', 'Soos and the Real Girl', '22', '2', '25'),
('77', '2', 'Little Gift Shop of Horrors', '22', '2', '26'),
('78', '2', 'Society of the Blind Eye', '22', '2', '27'),
('79', '2', 'Blendin\'s Game', '22', '2', '28'),
('80', '2', 'The Love God', '22', '2', '29'),
('81', '2', 'Northwest Mansion Mystery', '22', '2', '30'),
('82', '2', 'Not What He Seems', '22', '2', '31'),
('83', '2', 'A Tale of Two Stans', '22', '2', '32'),
('84', '2', 'Dungeons, Dungeons, and More Dungeons', '22', '2', '33'),
('85', '2', 'The Stanchurian Candidate', '22', '2', '34'),
('86', '2', 'The Last Mabelcorn', '22', '2', '35'),
('87', '2', 'Roadside Attraction', '22', '2', '36'),
('88', '2', 'Dipper and Mabel vs. the Future', '22', '2', '37'),
('89', '2', 'Weirdmageddon Part 1', '22', '2', '38'),
('90', '2', 'Weirdmageddon Part 2: Escape From Reality', '22', '2', '39'),
('91', '2', 'Weirdmageddon Part 3: Take Back the Falls', '22', '2', '40'),
('92', '2', 'Weirdmageddon Part 3: Somewhere in the Woods', '22', '2', '41'),
('93', '3', 'Pilot', '58', '1', '1'),
('94', '3', 'Cat\'s in the Bag...', '48', '1', '2'),
('95', '3', '...And the Bag\'s in the River', '47', '1', '3'),
('96', '3', 'Cancer Man', '48', '1', '4'),
('97', '3', 'Gray Matter', '48', '1', '5'),
('98', '3', 'Crazy Handful of Nothin\'', '48', '1', '6'),
('99', '3', 'A No-Rough-Stuff-Type Deal', '48', '1', '7'),
('100', '3', 'Seven Thirty-Seven', '47', '2', '8'),
('101', '3', 'Grilled', '48', '2', '9'),
('102', '3', 'Bit by a Dead Bee', '47', '2', '10'),
('103', '3', 'Down', '47', '2', '11'),
('104', '3', 'Breakage', '47', '2', '12'),
('105', '3', 'Peekaboo', '47', '2', '13'),
('106', '3', 'Negro y Azul', '48', '2', '14'),
('107', '3', 'Better Call Saul', '48', '2', '15'),
('108', '3', '4 Days Out', '47', '2', '16'),
('109', '3', 'Over', '47', '2', '17'),
('110', '3', 'Mandala', '47', '2', '18'),
('111', '3', 'Phoenix', '47', '2', '19'),
('112', '3', 'ABQ', '47', '2', '20'),
('113', '3', 'No Mas', '47', '3', '21'),
('114', '3', 'Caballo sin Nombre', '47', '3', '22'),
('115', '3', 'I.F.T.', '47', '3', '23'),
('116', '3', 'Green Light', '47', '3', '24'),
('117', '3', 'Mas', '47', '3', '25'),
('118', '3', 'Sunset', '47', '3', '26'),
('119', '3', 'One Minute', '47', '3', '27'),
('120', '3', 'I See You', '47', '3', '28'),
('121', '3', 'Kafkaesque', '47', '3', '29'),
('122', '3', 'Fly', '47', '3', '30'),
('123', '3', 'Abiquiu', '47', '3', '31'),
('124', '3', 'Half Measures', '47', '3', '32'),
('125', '3', 'Full Measure', '47', '3', '33'),
('126', '3', 'Box Cutter', '47', '4', '34'),
('127', '3', 'Thirty-Eight Snub', '47', '4', '35'),
('128', '3', 'Open House', '47', '4', '36'),
('129', '3', 'Bullet Points', '47', '4', '37'),
('130', '3', 'Shotgun', '47', '4', '38'),
('131', '3', 'Cornered', '47', '4', '39'),
('132', '3', 'Problem Dog', '47', '4', '40'),
('133', '3', 'Hermanos', '47', '4', '41'),
('134', '3', 'Bug', '47', '4', '42'),
('135', '3', 'Salud', '47', '4', '43'),
('136', '3', 'Crawl Space', '47', '4', '44'),
('137', '3', 'End Times', '47', '4', '45'),
('138', '3', 'Face Off', '47', '4', '46'),
('139', '3', 'Live Free or Die', '47', '5', '47'),
('140', '3', 'Madrigal', '47', '5', '48'),
('141', '3', 'Hazard Pay', '47', '5', '49'),
('142', '3', 'Fifty-One', '47', '5', '50'),
('143', '3', 'Dead Freight', '47', '5', '51'),
('144', '3', 'Buyout', '47', '5', '52'),
('145', '3', 'Say My Name', '47', '5', '53'),
('146', '3', 'Gliding Over All', '47', '5', '54'),
('147', '3', 'Blood Money', '47', '5', '55'),
('148', '3', 'Buried', '47', '5', '56'),
('149', '3', 'Confessions', '47', '5', '57'),
('150', '3', 'Rabid Dog', '47', '5', '58'),
('151', '3', 'To\'hajiilee', '47', '5', '59'),
('152', '3', 'Ozymandias', '47', '5', '60'),
('153', '3', 'Granite State', '47', '5', '61'),
('154', '3', 'Felina', '47', '5', '62'),
('155', '4', 'Uno', '52', '1', '1'),
('156', '4', 'Mijo', '45', '1', '2'),
('157', '4', 'Nacho', '46', '1', '3'),
('158', '4', 'Hero', '47', '1', '4'),
('159', '4', 'Alpine Shepherd Boy', '46', '1', '5'),
('160', '4', 'Five-O', '47', '1', '6'),
('161', '4', 'Bingo', '47', '1', '7'),
('162', '4', 'Rico', '46', '1', '8'),
('163', '4', 'Pimento', '49', '1', '9'),
('164', '4', 'Marco', '54', '1', '10'),
('165', '4', 'Switch', '47', '2', '11'),
('166', '4', 'Cobbler', '47', '2', '12'),
('167', '4', 'Amarillo', '46', '2', '13'),
('168', '4', 'Gloves Off', '46', '2', '14'),
('169', '4', 'Rebecca', '46', '2', '15'),
('170', '4', 'Bali Ha\'i', '46', '2', '16'),
('171', '4', 'Inflatable', '46', '2', '17'),
('172', '4', 'Fifi', '46', '2', '18'),
('173', '4', 'Nailed', '47', '2', '19'),
('174', '4', 'Klick', '47', '2', '20'),
('175', '4', 'Mabel', '47', '3', '21'),
('176', '4', 'Witness', '47', '3', '22'),
('177', '4', 'Sunk Costs', '47', '3', '23'),
('178', '4', 'Sabrosito', '47', '3', '24'),
('179', '4', 'Chicanery', '47', '3', '25'),
('180', '4', 'Off Brand', '47', '3', '26'),
('181', '4', 'Expenses', '47', '3', '27'),
('182', '4', 'Slip', '47', '3', '28'),
('183', '4', 'Fall', '47', '3', '29'),
('184', '4', 'Lantern', '47', '3', '30'),
('185', '4', 'Smoke', '47', '4', '31'),
('186', '4', 'Breathe', '47', '4', '32'),
('187', '4', 'Something Beautiful', '47', '4', '33'),
('188', '4', 'Talk', '47', '4', '34'),
('189', '4', 'Quite a Ride', '47', '4', '35'),
('190', '4', 'Pinata', '47', '4', '36'),
('191', '4', 'Something stupid', '47', '4', '37'),
('192', '4', 'Coushatta', '47', '4', '38'),
('193', '4', 'Wiedersehen', '47', '4', '39'),
('194', '4', 'Winner', '47', '4', '40'),
('195', '4', 'Magic Man', '47', '5', '41'),
('196', '4', '50% Off', '47', '5', '42'),
('197', '4', 'The guy for this', '47', '5', '43'),
('198', '4', 'Namaste', '47', '5', '44'),
('199', '4', 'Dedicado a Max', '47', '5', '45'),
('200', '4', 'Wexler v. Goodman', '47', '5', '46'),
('201', '4', 'JMM', '47', '5', '47'),
('202', '4', 'Bagman', '47', '5', '48'),
('203', '4', 'Bad Choice Road', '47', '5', '49'),
('204', '4', 'Something Unforgivable', '47', '5', '50'),
('205', '5', 'Pilot', '22', '1', '1'),
('206', '5', 'Quit Smoking', '22', '1', '2'),
('207', '5', 'Randy\'s Touch', '22', '1', '3'),
('208', '5', 'Faked My Own Death', '22', '1', '4'),
('209', '5', 'Teacher Earl', '22', '1', '5'),
('210', '5', 'Broke Joy\'s Fancy Figurine', '22', '1', '6'),
('211', '5', 'Stole Beer From a Golfer', '22', '1', '7'),
('212', '5', 'Joy\'s Wedding', '22', '1', '8'),
('213', '5', 'Cost Dad the Election', '22', '1', '9'),
('214', '5', 'White Lie Christmas', '22', '1', '10'),
('215', '5', 'Barn Burner', '22', '1', '11'),
('216', '5', 'O Karma, Where Art Thou?', '22', '1', '12'),
('217', '5', 'Stole P\'s HD Cart', '22', '1', '13'),
('218', '5', 'Monkeys in Space', '22', '1', '14'),
('219', '5', 'Something to Live For', '22', '1', '15'),
('220', '5', 'The Professor', '22', '1', '16'),
('221', '5', 'Didn\'t Pay Taxes', '22', '1', '17'),
('222', '5', 'Dad\'s Car', '22', '1', '18'),
('223', '5', 'Y2K', '22', '1', '19'),
('224', '5', 'Boogeyman', '22', '1', '20'),
('225', '5', 'The Bounty Hunter', '22', '1', '21'),
('226', '5', 'Stole a Badge', '22', '1', '22'),
('227', '5', 'BB', '22', '1', '23'),
('228', '5', 'Number One', '22', '1', '24'),
('229', '5', 'Very Bad Things', '22', '2', '25'),
('230', '5', 'Jump for Joy', '22', '2', '26'),
('231', '5', 'Sticks & Stones', '22', '2', '27'),
('232', '5', 'Larceny of a Kitty Cat', '22', '2', '28'),
('233', '5', 'Van Hickey', '22', '2', '29'),
('234', '5', 'Made a Lady Think I Was God', '22', '2', '30'),
('235', '5', 'Mailbox', '22', '2', '31'),
('236', '5', 'Robbed a Stoner Blind', '22', '2', '32'),
('237', '5', 'Born a Gamblin\' Man', '22', '2', '33'),
('238', '5', 'South of the Border, Part Uno', '22', '2', '34'),
('239', '5', 'South of the Border, Part Dos', '22', '2', '35'),
('240', '5', 'Our \'Cops\' Is On!', '22', '2', '36'),
('241', '5', 'Buried Treasure', '22', '2', '37'),
('242', '5', 'Kept a Guy Locked in a Truck', '22', '2', '38'),
('243', '5', 'Foreign Exchange Student', '22', '2', '39'),
('244', '5', 'B.L.O.W.', '22', '2', '40'),
('245', '5', 'The Birthday Party', '22', '2', '41'),
('246', '5', 'Guess Who\'s Coming Out of Joy', '22', '2', '42'),
('247', '5', 'Harassed a Reporter', '22', '2', '43'),
('248', '5', 'Two Balls Two Strikes', '22', '2', '44'),
('249', '5', 'G.E.D.', '22', '2', '45'),
('250', '5', 'Get a Real Job', '22', '2', '46'),
('251', '5', 'The Trial', '22', '2', '47'),
('252', '5', 'Camdenites, Part 1', '22', '3', '48'),
('253', '5', 'Camdenites, Part 2', '22', '3', '49'),
('254', '5', 'The Gangs of Camden County', '22', '3', '50'),
('255', '5', 'The Frank Factor', '22', '3', '51'),
('256', '5', 'Creative Writing', '22', '3', '52'),
('257', '5', 'Frank\'s Girl, Part 2', '22', '3', '53'),
('258', '5', 'Our Other Cops Is On!: Part 1', '22', '3', '54'),
('259', '5', 'Our Other Cops Is On!: Part 2', '22', '3', '55'),
('260', '5', 'Randy in Charge', '22', '3', '56'),
('261', '5', 'Midnight Bun', '22', '3', '57'),
('262', '5', 'Burn Victim', '22', '3', '58'),
('263', '5', 'Early Release', '22', '3', '59'),
('264', '5', 'Bad Earl', '22', '3', '60'),
('265', '5', 'I Won\'t Die With a Little Help From My Friends: Part 1', '22', '3', '61'),
('266', '5', 'I Won\'t Die With a Little Help From My Friends: Part 2', '22', '3', '62'),
('267', '5', 'Stole a Motorcycle', '22', '3', '63'),
('268', '5', 'No Heads and a Duffel Bag', '22', '3', '64'),
('269', '5', 'Killerball', '22', '3', '65'),
('270', '5', 'Love Octagon', '22', '3', '66'),
('271', '5', 'Girl Earl', '22', '3', '67'),
('272', '5', 'Camdenites, Part 1', '22', '3', '68'),
('273', '5', 'Camdenites, Part 2', '22', '3', '69'),
('274', '5', 'The Magic Hour', '22', '4', '70'),
('275', '5', 'Monkeys Take a Bath', '22', '4', '71'),
('276', '5', 'Joy in a Bubble', '22', '4', '72'),
('277', '5', 'Stole an RV', '22', '4', '73'),
('278', '5', 'Sweet Johnny', '22', '4', '74'),
('279', '5', 'We\'ve Got Spirit', '22', '4', '75'),
('280', '5', 'Quit Your Snitchin\'', '22', '4', '76'),
('281', '5', 'Little Bad Voodoo Brother', '22', '4', '77'),
('282', '5', 'Sold a Guy a Lemon Car', '22', '4', '78'),
('283', '5', 'Earl and Joy\'s Anniversary', '22', '4', '79'),
('284', '5', 'Nature\'s Game Show', '22', '4', '80'),
('285', '5', 'Reading Is a Funda Mental Case', '22', '4', '81'),
('286', '5', 'Orphan Earl', '22', '4', '82'),
('287', '5', 'Got the Babysitter Pregnant', '22', '4', '83'),
('288', '5', 'Darnell Outed: Part 1', '22', '4', '84'),
('289', '5', 'Darnell Outed: Part 2', '22', '4', '85'),
('290', '5', 'Randy\'s List Item', '22', '4', '86'),
('291', '5', 'Friends with Benefits', '22', '4', '87'),
('292', '5', 'My Name Is Alias', '22', '4', '88'),
('293', '5', 'Chaz Dalton\'s Space Academy', '22', '4', '89'),
('294', '5', 'Witch Lady', '22', '4', '90'),
('295', '5', 'Pinky', '22', '4', '91'),
('296', '5', 'Bullies', '22', '4', '92'),
('297', '5', 'Gospel', '22', '4', '93'),
('298', '5', 'Inside Probe: Part 1', '22', '4', '94'),
('299', '5', 'Inside Probe: Part 2', '22', '4', '95'),
('300', '5', 'Dodge\'s Dad', '22', '4', '96');


-- POPULATE GENRE TABLE

INSERT INTO genre
(genre_id, genre)
VALUES
('1', 'Action'),
('2', 'Adventure'),
('3', 'Animation'),
('4', 'Comedy'),
('5', 'Crime'),
('6', 'Drama'),
('7', 'Family'),
('8', 'Fantasy'),
('9', 'Horror'),
('10', 'Mystery'),
('11', 'Romance'),
('12', 'Science Fiction'),
('13', 'Thriller');

-- POPULATE MOVIE TABLE

INSERT INTO movie
(movie_id, title, release_year, length, rating)
VALUES
('1', 'No Time To Die', '2021', '163', 'PG-13'),
('2', 'Free Guy', '2021', '115', 'PG-13'),
('3', 'The Bad Guys', '2022', '100', 'PG'),
('4', 'Top Gun', '1986', '110', 'PG'),
('5', 'Top Gun: Maverick', '2022', '131', 'PG-13'),
('6', 'Where The Crawdads Sing', '2022', '126', 'PG-13'),
('7', 'Jaws', '1975', '124', 'PG'),
('8', 'Barbarian', '2022', '103', 'R'),
('9', 'Pearl', '2022', '102', 'R'),
('10', 'Spider-Man: No Way Home', '2021', '148', 'PG-13'),
('11', 'Glass Onion: A Knives Out Mystery', '2022', '140', 'PG-13'),
('12', 'Bullet Train', '2022', '126', 'R'),
('13', 'The King\'s Man', '2021', '131', 'R'),
('14', 'Dune', '2021', '155', 'PG-13'),
('15', 'Death On The Nile', '2022', '127', 'PG-13'),
('16', 'Uncharted', '2022', '116', 'PG-13'),
('17', 'The Batman', '2022', '177', 'PG-13'),
('18', 'Avatar: The Way of Water', '2022', '192', 'PG-13'),
('19', 'Puss In Boots: The Last Wish', '2022', '103', 'PG'),
('20', 'Sonic The Hedgehog 2', '2022', '123', 'PG');

-- POPULATE PROFILE TABLE

INSERT INTO profile
(profile_id, account_id, profile_name)
VALUES
('1', '1', 'Emily'),
('2', '1', 'James'),
('3', '2', 'Sophia'),
('4', '2', 'Liam'),
('5', '3', 'Olivia'),
('6', '4', 'Ethan'),
('7', '4', 'Ava'),
('8', '5', 'Noah'),
('9', '6', 'Isabella'),
('10', '6', 'Jackson');

-- POPULATE QUEUE TABLE

INSERT INTO queue
(profile_id, movie_id, series_id)
VALUES
('1', NULL, '1'),
('1', '5', NULL),
('1', '6', NULL),
('1', '14', NULL),
('2', '5', NULL),
('2', NULL, '3'),
('3', NULL, '2'),
('3', '5', NULL),
('4', '17', NULL),
('4', NULL, '4'),
('5', NULL, '1'),
('5', '14', NULL),
('6', '4', NULL),
('6', '5', NULL),
('6', NULL, '4'),
('7', '10', NULL),
('7', '15', NULL),
('7', '17', NULL),
('7', NULL, '1'),
('8', '19', NULL),
('8', '15', NULL),
('8', '20', NULL),
('8', '3', NULL),
('8', NULL, '2'),
('9', '12', NULL),
('9', NULL, '5'),
('9', '5', NULL),
('10', '4', NULL),
('10', '5', NULL),
('10', NULL, '1'),
('10', '15', NULL),
('10', '19', NULL);

-- POPULATE MOVIE_CAST TABLE

INSERT INTO movie_cast
(movie_id, actor_id)
VALUES
('1', '21'),
('1', '22'),
('1', '23'),
('1', '24'),
('2', '25'),
('2', '26'),
('2', '27'),
('2', '28'),
('3', '29'),
('3', '30'),
('3', '31'),
('3', '32'),
('4', '33'),
('4', '34'),
('4', '35'),
('4', '36'),
('5', '33'),
('5', '37'),
('5', '34'),
('5', '38'),
('6', '39'),
('6', '40'),
('6', '41'),
('6', '42'),
('7', '43'),
('7', '44'),
('7', '45'),
('7', '46'),
('8', '47'),
('8', '48'),
('8', '49'),
('8', '50'),
('9', '51'),
('9', '52'),
('9', '53'),
('9', '54'),
('10', '55'),
('10', '56'),
('10', '57'),
('10', '58'),
('11', '59'),
('11', '21'),
('11', '60'),
('11', '61'),
('12', '62'),
('12', '63'),
('12', '64'),
('12', '65'),
('13', '66'),
('13', '67'),
('13', '68'),
('13', '41'),
('14', '69'),
('14', '70'),
('14', '71'),
('14', '72'),
('15', '73'),
('15', '74'),
('15', '75'),
('15', '76'),
('16', '55'),
('16', '77'),
('16', '78'),
('16', '79'),
('17', '80'),
('17', '81'),
('17', '82'),
('17', '83'),
('18', '84'),
('18', '85'),
('18', '86'),
('18', '87'),
('19', '88'),
('19', '89'),
('19', '90'),
('19', '91'),
('20', '92'),
('20', '93'),
('20', '94'),
('20', '95');

-- POPULATE MOVIE_DIRECTOR TABLE

INSERT INTO movie_director
(movie_id, director_id)
VALUES
('1', '5'),
('2', '6'),
('3', '7'),
('4', '8'),
('5', '9'),
('6', '10'),
('7', '11'),
('8', '12'),
('9', '13'),
('10', '14'),
('11', '15'),
('12', '16'),
('13', '17'),
('14', '18'),
('15', '19'),
('16', '20'),
('17', '21'),
('18', '22'),
('19', '23'),
('20', '24');

-- POPULATE MOVIE_GENRE TABLE

INSERT INTO movie_genre
(movie_id, genre_id)
VALUES
('1', '1'),
('1', '6'),
('1', '13'),
('2', '2'),
('2', '4'),
('2', '12'),
('3', '1'),
('3', '2'),
('3', '3'),
('3', '4'),
('3', '5'),
('3', '7'),
('4', '1'),
('4', '5'),
('4', '6'),
('5', '1'),
('5', '6'),
('6', '6'),
('6', '10'),
('6', '11'),
('7', '2'),
('7', '9'),
('7', '13'),
('8', '9'),
('8', '10'),
('8', '13'),
('9', '6'),
('9', '9'),
('9', '13'),
('10', '1'),
('10', '2'),
('10', '12'),
('11', '4'),
('11', '5'),
('11', '10'),
('12', '1'),
('12', '4'),
('12', '13'),
('13', '1'),
('13', '2'),
('13', '13'),
('14', '2'),
('14', '12'),
('15', '5'),
('15', '10'),
('15', '13'),
('16', '1'),
('16', '2'),
('17', '5'),
('17', '10'),
('17', '13'),
('18', '1'),
('18', '2'),
('18', '12'),
('19', '1'),
('19', '2'),
('19', '3'),
('19', '4'),
('19', '7'),
('19', '8'),
('20', '1'),
('20', '2'),
('20', '4'),
('20', '7');

-- POPULATE MOVIE_HISTORY TABLE

INSERT INTO movie_history
(watchhistory_id, profile_id, movie_id)
VALUES
('1', '1', '1'),
('2', '1', '5'),
('3', '1', '6'),
('4', '1', '14'),
('5', '6', '4'),
('6', '6', '5'),
('7', '6', '10'),
('8', '7', '10'),
('9', '7', '15'),
('10', '7', '17'),
('11', '7', '18'),
('12', '8', '19'),
('13', '8', '15'),
('14', '8', '20'),
('15', '8', '3'),
('16', '10', '4'),
('17', '10', '5'),
('18', '10', '14'),
('19', '10', '15'),
('20', '10', '19');

-- POPULATE MOVIE_STUDIO TABLE

INSERT INTO movie_studio
(movie_id, studio_id)
VALUES
('1', '5'),
('2', '2'),
('3', '6'),
('4', '7'),
('5', '7'),
('5', '8'),
('6', '9'),
('6', '10'),
('7', '11'),
('8', '2'),
('8', '12'),
('9', '13'),
('10', '14'),
('11', '15'),
('12', '16'),
('13', '2'),
('14', '17'),
('15', '2'),
('16', '16'),
('16', '18'),
('17', '19'),
('17', '20'),
('18', '2'),
('18', '18'),
('19', '6'),
('19', '11'),
('20', '7'),
('20', '22');


-- POPULATE REVIEW_SCORE_MOVIE TABLE

INSERT INTO review_score_movie
(review_score_movie_id, score, movie_id, profile_id)
VALUES
('1', '1', '1', '1'),
('2', '5', '5', '1'),
('3', '5', '6', '1'),
('4', '2', '7', '1'),
('5', '4', '8', '1'),
('6', '5', '10', '1'),
('7', '1', '14', '1'),
('8', '2', '18', '1'),
('9', '5', '5', '8'),
('10', '2', '15', '8'),
('11', '4', '20', '8'),
('12', '3', '3', '8'),
('13', '2', '4', '10'),
('14', '3', '5', '10'),
('15', '5', '10', '10');

-- POPULATE REVIEW_SCORE_SERIES TABLE

INSERT INTO review_score_series
(review_score_series_id, score, series_id, profile_id)
VALUES
('1', '5', '1', '1'),
('2', '5', '2', '1'),
('3', '3', '3', '3'),
('4', '5', '1', '3'),
('5', '2', '3', '5'),
('6', '4', '5', '9');

-- POPULATE SERIES_CAST TABLE

INSERT INTO series_cast
(series_id, actor_id)
VALUES
('1', '1'),
('1', '2'),
('1', '3'),
('1', '4'),
('2', '5'),
('2', '6'),
('2', '7'),
('2', '8'),
('3', '9'),
('3', '10'),
('3', '11'),
('3', '12'),
('4', '13'),
('4', '14'),
('4', '15'),
('4', '16'),
('5', '17'),
('5', '18'),
('5', '19'),
('5', '20');

-- POPULATE SERIES_DIRECTOR TABLE

INSERT INTO series_director
(series_id, director_id)
VALUES
('1', '3'),
('2', '4'),
('3', '1'),
('4', '1'),
('5', '2');

-- POPULATE SERIES_GENRE TABLE

INSERT INTO series_genre
(series_id, genre_id)
VALUES
('1', '2'),
('1', '3'),
('1', '4'),
('1', '12'),
('2', '2'),
('2', '3'),
('2', '4'),
('2', '10'),
('3', '5'),
('3', '6'),
('3', '13'),
('4', '4'),
('4', '5'),
('4', '6'),
('5', '4');

-- POPULATE SERIES_HISTORY TABLE
INSERT INTO series_history
(profile_id, episodes_id, series_id)
VALUES
('1', '1', '1'),
('1', '2', '1'),
('1', '3', '1'),
('1', '4', '1'),
('1', '5', '1'),
('2', '93', '3'),
('2', '94', '3'),
('2', '95', '3'),
('2', '96', '3'),
('2', '52', '2'),
('2', '53', '2'),
('3', '206', '5'),
('3', '207', '5'),
('3', '208', '5'),
('3', '209', '5'),
('3', '210', '5'),
('4', '155', '4'),
('4', '156', '4'),
('4', '157', '4'),
('4', '158', '4'),
('4', '159', '4'),
('5', '1', '1'),
('5', '2', '1'),
('5', '3', '1'),
('5', '4', '1'),
('5', '5', '1'),
('6', '155', '4'),
('6', '156', '4'),
('6', '157', '4'),
('6', '158', '4'),
('6', '159', '4'),
('6', '160', '4'),
('6', '161', '4'),
('9', '206', '5'),
('9', '207', '5'),
('9', '208', '5'),
('9', '209', '5'),
('9', '210', '5'),
('9', '211', '5'),
('9', '212', '5'),
('9', '213', '5'),
('9', '214', '5'),
('9', '215', '5'),
('9', '216', '5'),
('9', '217', '5'),
('9', '218', '5');

-- POPULATE SERIES_STUDIO TABLE

INSERT INTO series_studio
(series_id, studio_id)
VALUES
('1', '3'),
('2', '4'),
('3', '1'),
('4', '1'),
('5', '2');




