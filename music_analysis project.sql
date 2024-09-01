--MUSIC DATASET ANALYSIS PROJECT

CREATE DATABASE Music_analysis
USE Music_analysis


--TABLES USED IN THIS ANALYSIS
--@album
--@album2
--@artist
--@customer
--@employee
--@genre
--@invoice
--@invoice_line
--@media_type
--@playlist
--@playlist_track
--@track


--ANALYZING THE DATA USING SQL QUERIES AND IMPLEMENTING ALL THE THING USED TO ANALYZE THE DATASET

--senior most employee based on title
SELECT TOP 1
title, last_name, first_name
FROM employee
ORDER BY levels DESC


--most invoices countries
SELECT count(*) AS c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c DESC


--TOP INVOICES FROM INVOICE TABLE
SELECT total
FROM invoice
ORDER BY total DESC


--city where best customers exist
SELECT TOP 1 
billing_city ,SUM(total) AS invoicetotal
FROM invoice
GROUP BY billing_city
ORDER BY invoicetotal DESC


--customer who spent most money will be the best
--customer
SELECT customer.customer_id, first_name,last_name,SUM(total) AS totalspending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id 
ORDER BY totalspending DESC


--getting the email and names of customer with track id
select * from invoice_line
SELECT DISTINCT email,first_name,last_name
FROM CUSTOMER
JOIN invoice ON customer.customer_id = invoice.customer_id
join invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
       SELECT track_id FROM track
	   join genre ON track.genre_id = genre.genre_id
	   WHERE genre.name LIKE 'rock'
)
ORDER BY email;


--getting the top 10artist name with number of songs
SELECT TOP 10
artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC


--getting songs name where songs length is longer than average length
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
                 SELECT AVG(milliseconds) AS avg_track_length
				 FROM track
)
ORDER BY milliseconds DESC


--now finding the most popular music genre for each country
WITH customer_with_country AS(
                    SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS ROW_NUMBER() 
					OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
					FROM invoice
					join customer ON customer.customer_id = invoice.customer_id
					GROUP BY 1,2,3,4
					ORDER BY 4 ASC, 5 DESC)
SELECT * FROM customer_with_country WHERE RowNo <= 1
