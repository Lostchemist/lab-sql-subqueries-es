USE sakila;

-- ¿Cuántas copias de la película El Jorobado Imposible existen en el sistema de inventario?

SELECT COUNT(*) AS "Number of Copies"
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'HUNCHBACK IMPOSSIBLE';


-- Lista todas las películas cuya duración sea mayor que el promedio de todas las películas.

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

SELECT 
    title, 
    length,
    CASE 
        WHEN length > (SELECT AVG(length) FROM film) THEN 'Above Average'
        ELSE 'Below Average'
    END AS duration_comparison
FROM 
    film;
    
    -- 3. Usa subconsultas para mostrar todos los actores que aparecen en la película Viaje Solo.
    
    SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'ALONE TRIP'
);

    SELECT actor.first_name, actor.last_name, f.title
FROM actor
JOIN film_actor fa ON actor.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title LIKE '%TRIP%';

-- Las ventas han estado disminuyendo entre las familias jóvenes, y deseas dirigir todas las películas familiares a una promoción. Identifica todas las películas categorizadas como películas familiares.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 5. Obtén el nombre y correo electrónico de los clientes de Canadá usando subconsultas. Haz lo mismo con uniones.

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';


-- ¿Cuáles son las películas protagonizadas por el actor más prolífico?

-- Encuentra el actor más POPULAR
SELECT actor_id, COUNT(film_id) AS film_count
FROM film_actor
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;

-- Encuentra las películas de ese actor
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);

-- 7. Películas alquiladas por el cliente más rentable.

-- Encuentra el cliente más rentable
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- Encuentra las películas alquiladas por ese cliente
SELECT f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- Obtén el customer_id y el total_amount_spent de esos clientes que gastaron más que el promedio del total_amount gastado por cada cliente.

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (SELECT AVG(total_spent) FROM (SELECT SUM(amount) AS total_spent FROM payment GROUP BY customer_id) AS avg_total);





    
