# Neo4J/Relational Database comparison

## Setup:
Running the project should be reasonably simple, requiring just a computer with vagrant and a network connection.
Run these commands from the project root folder:
$ vagrant up && vagrant ssh

This will set up and start the vagrant.

$ cd /vagrant
$ ./installscript

This installs dependencies, fetches data and imports it into the databases, running inside docker containers.

## Benchmarking

$ python3 dbApp.py

This command will run a python program that picks 20 random person IDs, verifies that they exist in the database and then runs a series of benchmark queries on those IDs