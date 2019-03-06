CREATE TABLE cdad3(
	ciudad varchar(40) NOT NULL,
	pais varchar(40) NOT NULL,
	latitud float NOT NULL,
	longitud float NOT NULL,
	poblacion float NOT NULL
	
);


COPY cdad3 (ciudad,pais,latitud,longitud,poblacion) from '/home/jd-ubuntu/Documentos/Bases1/prueba.csv' delimiter ',' csv header;

SELECT * from cdad3;

/*Consulta1:
Para cada ciudad C1 muestre la ciudad C2 que es la que le sigue con una
población inmediatamente menor. Si no existe una ciudad C2, indíquelo con NULL.
*/
SELECT ciudad,poblacion FROM cdad3 
ORDER BY poblacion DESC 
LIMIT 2 OFFSET 2
