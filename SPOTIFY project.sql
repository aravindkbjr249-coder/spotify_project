-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


SELECT * FROM spotify;

SELECT COUNT(*)FROM spotify;

SELECT * FROM spotify
WHERE duration_min=0


DELETE FROM spotify
WHERE duration_min=0


---retrive the names of all tracks that have a stream greater than 1 billion 

SELECT * FROM spotify
WHERE stream>1000000000;

--List all album with the respective artist

SELECT
DISTINCT album, artist
FROM spotify;


--Retrieve the total number of comments for tracks where licensed is equal=true.

SELECT 
SUM(comments) FROM spotify
WHERE licensed='true'

--Select all tracks belonging to the album type single.

SELECT * FROM spotify
WHERE album_type ILIKE 'single'

--Count the total number of tracks by each artist.

SELECT  artist,
COUNT(*) AS total_no_song
FROM spotify
GROUP BY artist
ORDER BY 2 DESC


--Calculate average danceability of tracks in each album.

SELECT album,
AVG(danceability) as avg_danceability
FROM spotify
GROUP BY 1

--Find the top five tracks with the highest energy values.

SELECT track,
MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--List all tracks along with their views and likes where official_video =true.

SELECT track,
SUM(views) as total_views,
SUM(likes) as total_likes
FROM spotify
WHERE official_video ='true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--For each album, calculate the total use of all associated tracks.

SELECT album, track,
SUM(views)
FROM spotify
GROUP BY 1,2
ORDER BY 2 DESC



----Find the top three most viewed tracks for each artist using the window function.

WITH ranking_artist
AS

(SELECT

artist,

track,

SUM(views) as total_view,

DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM (views) DESC) as rank FROM spotify

GROUP BY 1, 2

ORDER BY 1, 3 DESC
)

SELECT * FROM ranking_artist

WHERE rank <=3


--write query to find tracks where the liveness core is above average.

SELECT

artist,

liveness

FROM spotify

WHERE liveness > (SELECT AVG(liveness) FROM spotify)

-- use with clause to  calculate the difference between the highest and the lowest energy values for tracking each album.

WITH cte

AS

(SELECT

album,

MAX(energy)as highest_energy,

MIN(energy) as lowest_energery

FROM spotify 
GROUP BY 1
)
SELECT

album,

highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC

ORDER BY 2 DESC