SELECT *   
FROM wp_posts
INTO OUTFILE '/var/lib/mysql/wp_posts.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
