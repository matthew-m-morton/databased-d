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
DROP TABLE IF EXISTS `mmdb`.`queue` ;

CREATE TABLE IF NOT EXISTS `mmdb`.`queue` (
  `profile_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  `series_id` INT NOT NULL,
  PRIMARY KEY (`profile_id`, `movie_id`, `series_id`),
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
    ON UPDATE NO ACTION)
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
  `episode_name` VARCHAR(45) NOT NULL,
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
