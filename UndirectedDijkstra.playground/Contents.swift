public class Vertex {
    var key: String?
    var neighbors: Array<Edge>
    init() {
        self.neighbors = Array<Edge>()
    }
}

public class Edge {
    var neighbor: Vertex
    var weight: Int
    var visited: Bool?
    init() {
        weight = 0
        self.neighbor = Vertex()
    }
}

class Path {
    var total: Int!
    var destination: Vertex
    var previous: Path!
    //object initialization
    init(){ destination = Vertex() }
}

public class SwiftGraph {
    private var canvas: Array<Vertex>
    public var isDirected: Bool
    init() {
        canvas = Array<Vertex>()
        isDirected = false
        
    }
    //create a new vertex
    func addVertex(key: String) -> Vertex {
        //set the key
        var childVertex: Vertex = Vertex()
        childVertex.key = key
        //add the vertex to the graph canvas
        canvas.append(childVertex)
        return childVertex
    }
    func addEdge(source: Vertex, neighbor: Vertex, weight: Int) {
        //create a new edge
        var newEdge = Edge()
        //establish the default properties
        newEdge.neighbor = neighbor
        newEdge.weight = weight
        newEdge.visited = false
        source.neighbors.append(newEdge)
        //check for undirected graph
        if (isDirected == false) {
            //create a new reversed edge
            var reverseEdge = Edge()
            //establish the reversed properties
            reverseEdge.neighbor = source
            reverseEdge.weight = weight
            reverseEdge.visited = false
            neighbor.neighbors.append(reverseEdge)
        }
    }
    func processDijkstra(source: Vertex, destination: Vertex) -> Path? {
        var frontier: Array<Path> = Array<Path>()
        var finalPaths: Array<Path> = Array<Path>()
        
        // source.visited = false ?!?! dont need it
        
        //use source edges to create the frontier
        for e in source.neighbors {
            var newPath: Path = Path()
            newPath.destination = e.neighbor
            newPath.previous = nil
            newPath.total = e.weight
            e.visited = true
            //add the new path to the frontier
            frontier.append(newPath)
            
        }
        
        //obtain the best path
        var bestPath: Path = Path()
        while(frontier.count != 0) {
            //support path changes using the greedy approach
            bestPath = Path()
            var x: Int = 0
            var pathIndex: Int = 0
            
            for (x = 0; x < frontier.count; x++) {
                var itemPath: Path = frontier[x] as Path
                if (bestPath.total == nil) || (itemPath.total < bestPath.total) {
                    bestPath = itemPath
                    pathIndex = x
                }
            }
            
            
            
            ///// ---------- BEST PATH LOOP
            for e in bestPath.destination.neighbors {
                var newPath: Path = Path()

                if (e.visited == false) {
                    e.visited = true
                    newPath.destination = e.neighbor
                    newPath.previous = bestPath
                    newPath.total = bestPath.total + e.weight
                    //add the new path to the frontier
                    frontier.append(newPath)
                }
                
            }
            
            //preserve the bestPath
            finalPaths.append(bestPath)
            //remove the bestPath from the frontier
            frontier.removeAtIndex(pathIndex)
            
        }
        
        
        
        printSeperator("FINALPATHS")
        printPaths(finalPaths as [Path], source: source)
        printSeperator("BESTPATH BEFORE")
        printPath(bestPath, source: source)
        for p in finalPaths {
            var path = p as Path
            if (path.total < bestPath.total) && (path.destination.key == destination.key){
                bestPath = path
            }
        }
        printSeperator("BESTPATH AFTER")
        printPath(bestPath, source: source)
        return bestPath
    }
    
    func printPath(path: Path, source: Vertex) {
        print("BP: weight- \(path.total) \(path.destination.key!) ")
        if path.previous != nil {
            printPath(path.previous!, source: source)
        } else {
            print("Source : \(source.key!)")
        }
    }
    
    func printPaths(paths: [Path], source: Vertex) {
        for path in paths {
            printPath(path, source: source)
        }
    }
    
    func printLine() {
        print("*******************************")
    }
    
    func printSeperator(content: String) {
        printLine()
        print(content)
        printLine()
    }
}

///* TEST 1
///* Wikipedia Undirected Dijkstra graph
///* Link: https://en.wikipedia.org/wiki/Dijkstra's_algorithm

var graph = SwiftGraph()

var d1 = graph.addVertex("d1")
var d2 = graph.addVertex("d2")
var d3 = graph.addVertex("d3")
var d4 = graph.addVertex("d4")
var d5 = graph.addVertex("d5")
var d6 = graph.addVertex("d6")

graph.addEdge(d1, neighbor: d2, weight: 7)
graph.addEdge(d1, neighbor: d3, weight: 9)
graph.addEdge(d1, neighbor: d6, weight: 14)
graph.addEdge(d2, neighbor: d3, weight: 10)
graph.addEdge(d2, neighbor: d4, weight: 15)
graph.addEdge(d3, neighbor: d4, weight: 11)
graph.addEdge(d3, neighbor: d6, weight: 2)
graph.addEdge(d4, neighbor: d5, weight: 6)
graph.addEdge(d6, neighbor: d5, weight: 9)

var path = graph.processDijkstra(d5, destination: d1)
