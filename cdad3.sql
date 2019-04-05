/*
*PROYECTO 1
*@version 1.0 24/03/2019
*@author Juan Diego Porras 12-10566
*@author Victoria Torres 12-11468
*/


DROP TABLE IF EXISTS cdad3 CASCADE;

--CREATE DATABASE TAREA1 WITH OWNER postgres;

/* CREA LA BASE DE DATOS*/
CREATE DATABASE TAREA1

/* INGRESAMOS A LA BASE DE DATOS*/
\c tarea1;

/*CREAR TABLA*/

CREATE TABLE cdad3(
    ID  SERIAL PRIMARY KEY,
	ciudad varchar(40) NOT NULL,
	latitud float NOT NULL,
	longitud float NOT NULL,
	pais varchar(100) NOT NULL,
	poblacion float
);


/*COPIAR DATOS DEL CSV EN LA TABLA*/
COPY cdad3 (ciudad,latitud,longitud,pais,poblacion) from '/home/jd-ubuntu/Documentos/Bases1/tarea/pruebaMediana.csv' delimiter ',' csv header;

/*MOSTRAR TABLA*/
SELECT * from cdad3;

/*Consulta1:
Para cada ciudad C1 muestre la ciudad C2 que es la que le sigue con una
población inmediatamente menor. Si no existe una ciudad C2, indíquelo con NULL.
*/


/*Select c1.ciudad,
	Case
		When (Select Max(c3.poblacion)
			      From cdad3 c3
			      Where c1.poblacion > c3.poblacion) is not null
			Then (Select c3.ciudad
			          From cdad3 c3
			          Where c3.poblacion = (Select Max(c3.poblacion)
			                                    From cdad3 c3
			                                    Where c1.poblacion > c3.poblacion))
        Else 'NULL'
    End as CiudadInmediatamenteMenor
From cdad3 c1;*/

SELECT DISTINCT c1.ciudad, c2.ciudad AS Ciudad_Poblacion_InmdMenor
FROM cdad3 c1, cdad3 c2
WHERE c2.poblacion = (SELECT MAX(c3.poblacion)
					  FROM cdad3 c3
					  WHERE c1.poblacion > c3.poblacion)
UNION
SELECT c1.ciudad,NULL
FROM cdad3 c1
WHERE poblacion IS NULL
	
	OR poblacion = (SELECT MIN(c3.poblacion)
					  FROM cdad3 c3);
GROUP BY c1.ciudad
ORDER BY ciudad;

/*Consulta2:
El recuadro (x1,y1,x2,y2) que engloba a todas las ciudades de cada país
o Schema de Respuesta: (Country, lat1,lng1,lat2,lng2)*/

SELECT pais, MIN(latitud) AS Lat1, MIN(longitud) AS Lng1, 
             MAX(latitud) AS Lat2, MAX(longitud) AS Lng2 FROM cdad3
GROUP BY pais
ORDER BY pais;

/*Consulta3:
Las 2 ciudades más distantes entre si o Schema de Respuesta: (City1, Lat1, Lng1, City2, Lat2, Lng2)*/

SELECT c1.ciudad AS City1, c1.latitud AS Lat1, c1.longitud AS Lng1,
	   c2.ciudad AS City2, c2.latitud AS Lat2, c2.longitud AS Lng2,
	   MAX(sqrt(Power(c1.longitud - c2.longitud, 2) + Power(c1.latitud - c2.latitud, 2))) AS Distancia
	   FROM cdad3 c1, cdad3 c2

GROUP BY c1.ciudad, c1.latitud, c1.longitud,
         c2.ciudad, c2.latitud, c2.longitud
ORDER BY Distancia DESC
LIMIT 1;

/*Consulta 4:
  Para cada ciudad, las 3 ciudades más cercanas y sus respectivas distancias
  Schema de Respuesta: (City, City1, Distance1, City2, Distance2, City3, Distance3)*/

/*Select Distinct City, City1, Distance1, City2, Distance2, City3, Distance3 From ( 
	        Select
	            c1.ciudad as City,
	            c2.ciudad as City1 ,
	            Min(sqrt(Power(c1.longitud - c2.longitud, 2) + Power(c1.latitud - c2.latitud, 2))) as Distance1,
	            c3.ciudad as City2 ,
	            Min(sqrt(Power(c1.longitud - c3.longitud, 2) + Power(c1.latitud - c3.latitud, 2))) as Distance2,
	            c4.ciudad as City3,
	            Min(sqrt(Power(c1.longitud - c4.longitud, 2) + Power(c1.latitud - c4.latitud, 2))) as Distance3
	            From cdad3 c1, cdad3 c2, cdad3 c3, cdad3 c4
	         	Where c1.ciudad != c2.ciudad And c1.ciudad != c3.ciudad And c1.ciudad != c4.ciudad And
	         	      c2.ciudad != c3.ciudad And c2.ciudad != c4.ciudad And
	         	      c3.ciudad != c4.ciudad
	            Group By c1.ciudad, c1.longitud, c1.latitud,
	                     c2.ciudad, c2.longitud, c2.latitud,
	                     c3.ciudad, c3.longitud, c3.latitud,
	                     c4.ciudad, c4.longitud, c4.latitud
	            Limit 1) as de; ÑO */

/* Aqui tomamos las tres mas cercanas para una ciudad
Select Distinct City, City1, Distance1 From ( 
	        Select
	            c1.ciudad as City,
	            c2.ciudad as City1 ,
	            Min(sqrt(Power(c1.longitud - c2.longitud, 2) + Power(c1.latitud - c2.latitud, 2))) as Distance1
	            From cdad3 c1, cdad3 c2
	         	Where c1.ciudad != c2.ciudad And c1.ciudad = 'Wudui'
	         		  
	            Group By c1.ciudad, c1.longitud, c1.latitud,
	                     c2.ciudad, c2.longitud, c2.latitud
	            ) as de
				Order By Distance1
				; 

Select Distinct City, City1, Distance1 From ( 
	        Select
	            c1.ciudad as City,
	            c2.ciudad as City1 ,
	            Min(sqrt(Power(c1.longitud - c2.longitud, 2) + Power(c1.latitud - c2.latitud, 2))) as Distance1
	            From cdad3 c1, cdad3 c2
	         	Where c1.ciudad != c2.ciudad
	            Group By c1.ciudad, c1.longitud, c1.latitud,
	                     c2.ciudad, c2.longitud, c2.latitud
	            --Order By Distance1
	            ) as de
				Order By City, Distance1; 
*/

/*NUEVA CONSULTA 4
CREATE VIEW Distancias AS
SELECT c1.ciudad AS City, c2.ciudad AS City1, (Select Min(sqrt(Power(c1.longitud - c2.longitud, 2) + Power(c1.latitud - c2.latitud, 2))) AS D
ORDER BY D Asc) AS Distance1
FROM cdad3 c1, cdad3 c2
WHERE c1.ciudad != c2.ciudad
GROUP BY c2.ciudad, c1.ciudad
ORDER BY c1.ciudad, Distance1;

-- Query solicitado

SELECT DISTINCT ref.City, c1.City1, c1.Distance1, c2.City1 as City2, c2.Distance1 As Distance2, c3.City1 as City3, c3.Distance1 as Distance3
FROM Distancias ref, Distancias c1, Distancias c2, Distancias c3
WHERE ref.City = c1.City AND ref.City = c2.City AND ref.City = c3.City
AND c1.Distance1 = (SELECT MIN(Distance1) FROM Distancias WHERE City = ref.City)
AND c2.Distance1 = (SELECT Distance1 FROM Distancias WHERE City = ref.City ORDER BY Distance1 ASC LIMIT 1 OFFSET 1)
AND c3.Distance1 = (SELECT Distance1 FROM Distancias WHERE City = ref.City ORDER BY Distance1 ASC LIMIT 1 OFFSET 2)
ORDER BY ref.City;
*/


CREATE VIEW Dist_C1_C2 AS

	SELECT c1.ciudad AS City, c2.ciudad AS City1,
		  (SELECT MIN(sqrt(Power(c1.longitud - c2.longitud, 2) + Power(c1.latitud - c2.latitud, 2))) AS Distancia
		   ORDER BY Distancia Asc) AS Dist_C_C1
	FROM cdad3 c1, cdad3 c2

	WHERE c1.ciudad != c2.ciudad
	GROUP BY c1.ciudad, c2.ciudad
	ORDER BY c1.ciudad, Dist_C_C1;

SELECT DISTINCT c.City, c1.City1, c1.Dist_C_C1 AS Distancia_1,
				c2.City1 AS City2, c2.Dist_C_C1 AS Distancia_2,
				c3.City1 AS City3, c3.Dist_C_C1 AS Distancia_3
FROM Dist_C1_C2 c, Dist_C1_C2 c1, Dist_C1_C2 c2, Dist_C1_C2 c3

WHERE c.City = c1.City AND c.City = c2.City AND c.City = c3.City

	AND c1.Dist_C_C1 = (SELECT MIN(Dist_C_C1)
	  					FROM Dist_C1_C2
	  					WHERE City = c.City)

	AND c2.Dist_C_C1 = (SELECT Dist_C_C1
	  					FROM Dist_C1_C2
	  					WHERE City = c.City
	  					ORDER BY Dist_C_C1 ASC
	  					LIMIT 1 OFFSET 1)

	AND c3.Dist_C_C1 = (SELECT Dist_C_C1
	  					FROM Dist_C1_C2
	  					WHERE City = c.City
	  					ORDER BY Dist_C_C1 ASC
	  					LIMIT 1 OFFSET 2)
ORDER BY c.City;
