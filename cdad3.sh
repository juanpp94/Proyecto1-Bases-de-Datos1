#!/bin/bash
wget https://simplemaps.com/static/data/world-cities/basic/simplemaps_worldcities_basicv1.4.zip
unzip simplemaps_worldcities_basicv1.4.zip
rm simplemaps_worldcities_basicv1.4.zip  worldcities.xlsx license.txt 
mv -v worldcities.csv pruebaMediana.csv

psql -f cdad3.sql
