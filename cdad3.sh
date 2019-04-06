#!/bin/bash
wget https://raw.githubusercontent.com/juanpp94/Proyecto1-Bases-de-Datos1/master/pruebaMediana.csv
sudo -u postgres psql -f cdad3.sql
