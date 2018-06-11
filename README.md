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

## Results

1.0171537399291992      1.3818023204803467      13.978486061096191
2.422504425048828       1.4123542308807373      4.009984731674194
1.6467597484588623      1.410991907119751       1.9101033210754395
1.2183952331542969      1.2359418869018555      6.269052982330322
1.1318397521972656      1.2269072532653809      1.6767468452453613
1.1274657249450684      1.1510114669799805      5.6676647663116455
1.3151566982269287      1.5057687759399414      4.377062559127808
1.511059045791626       1.5900161266326904      6.812897443771362
1.7677135467529297      1.3479819297790527      3.7191574573516846
1.3381297588348389      1.312652349472046       1.4634146690368652
1.2995710372924805      1.3095393180847168      3.43396258354187
1.3280932903289795      1.5355274677276611      1.7909972667694092
0.9149084091186523      1.3168816566467285      2.1647865772247314
1.1418704986572266      1.1414437294006348      1.3994331359863281
1.1708755493164062      1.104064702987671       1.339120626449585
1.1106135845184326      1.2198498249053955      1.5444610118865967
1.139103651046753       1.1148285865783691      1.3247778415679932
1.4502034187316895      1.3919806480407715      1.4201123714447021
1.1731457710266113      1.3042278289794922      6.995439529418945
1.2516999244689941      1.2530453205108643      2.3370444774627686
AVERAGE
1.3238131403923035      1.3133408665657043      3.6817353129386903
MEDIAN
1.2350475788116455      1.3110958337783813      2.25091552734375


## Relational database

I had a lot of trouble getting a relational database to run as well as import data. Either they were unable to start and stay running, or would not accept connections across Docker's legacy link interface, as was the case with mysql.

## Results

Since I only have results from one DBMS, I am unable to come to any concrete conclusion with regards to the correct Database for this use case.
