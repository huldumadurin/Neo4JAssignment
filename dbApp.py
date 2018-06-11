from neo4j.v1 import GraphDatabase
import MySQLdb, random, time, statistics



def connectMySQL():
    return MySQLdb.connect(host='localhost', user='root', passwd='pwd', db="social")

def connectNeo4J():
    return GraphDatabase.driver("bolt://localhost:7687")
    
#__mysqldb = connectMySQL()
__neo4jdb = connectNeo4J()
MAX_DEPTH = 5

def getRandomPersonList():
    ids = []
    newid = "FIRST"
    
    for i in range(20):
        while newid in ids or newid == "FIRST":
            print("New ID = " + str(newid))
            newid = getRandomExistingPerson()
        ids.append(newid)
        print(ids)
    return ids


def getRandomExistingPerson():
    while True:
        
        node_id = random.randint(0, 499999)
        person = None
        
        with __neo4jdb.session() as session:
            print("Checking id: " + str(node_id))
            person = session.run("MATCH (p:Person {node_id:$node_id}) "
                             "RETURN p", node_id=str(node_id)).single().value()
        
        print(person)
        if not person is None:
            return person['node_id']

def doQueryNeo4J(node_id, depth):
    with __neo4jdb.session() as session:
            return session.run("MATCH (:Person {node_id:$node_id})-[:ENDORSES * "+str(depth)+"]->(r)"
                             "RETURN DISTINCT r", node_id=str(node_id), depth=depth)

def doBenchmarkNeo4J(people):
    times = []
    start = 0
    
    for p in people:
        ptimes = []
        
        for i in range(1, MAX_DEPTH  +1):
            start = time.time()
            res = doQueryNeo4J(p, i)
            ptimes.append(time.time()-start)
            #print(str(res.single().value()) + " people found endorsed by id: " + p + ", in " + str(ptimes[i-1]) + " sec, at depth " + str(i))
            #print(str(len(res.list())) + "Endorsees by id: " + p + " at depth " + str(i) + ", in " + str(ptimes[i-1]) + " sec")
            print("Endorsees by id: " + p + " at depth " + str(i) + ", in " + str(ptimes[i-1]) + " sec")
        times.append(ptimes)
        
    return times

def deriveTimes(list2d):
    avgs = []
    medians = []
    
    #Average
    for i in range(MAX_DEPTH):
        col = [row[i] for row in list2d]
        avgs.append(statistics.mean(col))
        medians.append(statistics.median(col))
    
    return [avgs, medians]
    
def runBenchmarks():
    return NotImplementedError()
    
def runQuery(depth, db):
    return NotImplementedError()

people = getRandomPersonList()
#people = ['296835', '66401', '72414', '62369', '261830', '105473', '154317', '157175', '57823', '86381', '374697', '350801', '90841', '346166', '41589', '489247', '77510', '194676', '391112', '96145']

times = doBenchmarkNeo4J(people)
print("\n\n\n")
print(times)
ctimes = deriveTimes(times)
print("AVERAGE")
print(ctimes[0])
print("MEDIAN")
print(ctimes[1])
