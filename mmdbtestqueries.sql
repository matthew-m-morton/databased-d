USE mmdb;


-- Movies with their respective ratings
SELECT title, ROUND(AVG(score), 1) AS average_score
FROM movie m JOIN review_score_movie r 
	ON m.movie_id = r.movie_id
GROUP BY r.movie_id, title
ORDER BY AVG(score) DESC;

-- Movies with Tom Holland
SELECT title, CONCAT(a.first_name, ' ',a.last_name) AS name
FROM movie m JOIN movie_cast cast 
	ON m.movie_id = cast.movie_id JOIN actor a
    ON cast.actor_id = a.actor_id
WHERE a.first_name = "Tom" AND a.last_name = "Holland";


-- Movies with actors with first name Tom
SELECT title, CONCAT(a.first_name, ' ',a.last_name) AS name
FROM movie m JOIN movie_cast cast 
	ON m.movie_id = cast.movie_id JOIN actor a
    ON cast.actor_id = a.actor_id
WHERE a.first_name = "Tom";


-- profile queue for Noah
SELECT m.title
FROM movie m JOIN movie_genre mg
	ON m.movie_id = mg.movie_id JOIN genre g
	ON g.genre_id = mg.genre_id
WHERE genre = "comedy";

