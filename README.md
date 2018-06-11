# Neo4J/Relational Database comparison

## Setup:
Running the project should be reasonably simple, requiring just a computer with vagrant and a network connection.
Run these commands from the project root folder:
$ vagrant up && vagrant ssh

This will set up and start the vagrant.

$ cd /vagrant
$ ./installscript

This installs dependencies, fetches data and imports it into the databases, running inside docker containers. Python3 and pip3 will be installed, as well as a few dependencies. This script also edits the CSV headers to work with Neo4J

## Benchmarking

$ python3 dbApp.py

This command will run a python program that picks 20 random person IDs, verifies that they exist in the database and then runs a series of benchmark queries on those IDs

## Neo4j

Neo4J is automatically started and populated with data from CSV by installscript.sh

## Relational database

I had a lot of trouble getting a relational database to run as well as import data. Either they were unable to start and stay running, or would not accept connections across Docker's legacy link interface, as was the case with mysql.

## Results

Since I only have results from one DBMS, I am unable to come to any concrete conclusion with regards to the correct Database for this use case.