#echo "Installing python3, pip3 and libraries"
sudo -H apt-get install -y python3-pip
sudo -H apt-get install -y python3-mysqldb
sudo -H pip3 install --upgrade pip==9.0.3
sudo -H pip3 install neo4j-driver

#Fetching and extracting data
cd /vagrant
mkdir -p import
mkdir -p data
#    wget -N option not working, since github does not give out Last-Modified header for raw files
wget https://github.com/datsoftlyngby/soft2018spring-databases-teaching-material/raw/master/data/archive_graph.tar.gz -O archive_graph.tar.gz
cd import
tar -xvzf ../archive_graph.tar.gz
#Cleaning up headers:
sed "s/source_node_id,target_node_id/source_node_id:START_ID,target_node_id:END_ID/" social_network_edges.csv > edges_fixed.csv
#mv edges_fixed.csv social_network_edges.csv
sed "s/node_id,name,job,birthday/node_id:ID,name:string,job:string,birthday:string/" social_network_nodes.csv > nodes_fixed.csv
#mv nodes_fixed.csv social_network_nodes.csv

#Removing archive to prevent duplicates on next run
cd /vagrant
rm archive_graph.tar.gz

#Deleting any social database already in place:
rm -r data/databases 2> /dev/null

docker run -d -e NEO4J_AUTH=none -e NEO4J_CACHE_MEMORY=1G -e NEO4J_HEAP_MEMORY=2G -p 7474:7474 -p 7687:7687 -v $PWD/data:/data -v $PWD/import:/var/lib/neo4j/import --name neo4jdocker neo4j:latest
docker exec -i neo4jdocker bin/neo4j-import --into /data/databases/social.db --nodes:Person /var/lib/neo4j/import/nodes_fixed.csv --relationships:ENDORSES /var/lib/neo4j/import/edges_fixed.csv

docker stop neo4jdocker
docker rm neo4jdocker

rm -r data/databases/graph.db
mv data/databases/social.db data/databases/graph.db

docker run -d -e NEO4J_AUTH=none -e NEO4J_CACHE_MEMORY=2G -e NEO4J_HEAP_MEMORY=5G -p 7474:7474 -p 7687:7687 -v $PWD/data:/data -v $PWD/import:/var/lib/neo4j/import --name neo4jdocker neo4j:latest


##postgres
#docker run -d --name postgres -p 5432:5432 -v $PWD/import:/docker-entrypoint-initdb.d -e POSTGRES_USER=user -e POSTGRES_PASSWORD=pwd -e POSTGRES_DB=social postgres:alpine
#
#docker run -d --name postgres -p 5432:5432 -v $PWD/import:/docker-entrypoint-initdb.d -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=social postgres:alpine
#
#docker exec -u postgres pg_test psql postgres postgres -f docker-entrypoint-initdb.d/tables.sql

#mysql
#docker run -p 3306:3306 -v $PWD/import:/import --name mysqldocker -e MYSQL_ROOT_PASSWORD=rootpwd -d mysql:latest
#docker run -it --link mysqldocker:mysql --rm mysql sh -c 'exec mysql -h "localhost" -P "3306"' < ./import/tables.sql

#mssql
#docker run -e 'ACCEPT_EULA=Y' --name mssql -e 'SA_PASSWORD=temppwd' -e 'MSSQL_PID=Express' -p 1433:1433 -d microsoft/mssql-server-linux:latest
#docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P temppwd < ./import/tables.sql