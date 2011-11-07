class Network
  
  attr_accessor :layers
  
  def initialize(layer_count)
    @layers = Array.new()
    puts "Creating network..."
    for i in 0..layer_count-1
      puts "What do you want this layer to be called?"
      layer_type = gets
      layer = Layer.new(layer_type)
      @layers<<layer
    end
  end
  
  #def self.layers
   # @layers
  #end
  
  def run
    for i in 0..@layers.length-1
      thisLayer = @layers[i]
      puts "For layer #{i}: There are #{thisLayer.nodes.length} nodes"
      
      theseNodes = thisLayer.nodes
      
      for j in 0..theseNodes.length-1
        
        thisNode = theseNodes[j]
        theseEdges = thisNode.edges
        
        sum = 0;
        
        for k in 0..theseEdges.length-1
          
          thisEdge = theseEdges[k]
          sum += thisEdge.weight * thisNode.value
          
        end
        
        thisNode.value = sum
        
        if i == @layers.length-1
          puts "Node #{j} = #{thisNode.value}"
        end
        
      end
      
    end
    
  end
      
  
end

class Layer
  
  attr_accessor :name, :nodes
  
  def initialize(layer_name)
    @name = layer_name
    @nodes = Array.new
  end
  
  def addNode(node)
    @nodes.push(node)
  end
  
  def nodes
    if @nodes.length > 0
      return @nodes
    else
      return Array.new
    end
  end
  
  def self.push(node)
    @nodes<<node
  end
  
end

class Node
  
  attr_accessor :value, :edges
  
  def initialize(my_value)
    @value = my_value
    @edges = Array.new
  end
  
  def addEdge(edge)
    @edges.push(edge)
  end
  
end

class Edge
  
  attr_accessor :weight, :source, :target
  
  def initialize(my_weight, my_source, my_target)
    @weight = my_weight
    @source = my_source
    @target = my_target
  end

end

# Main
theNetwork = Network.new(3)

# Set up network layout

# Input layer...

# Create nodes...
iNode1 = Node.new(0)
iNode2 = Node.new(0)
iNode3 = Node.new(0)

# Create edges
iEdge1 = Edge.new(1.0,nil,iNode1)
iEdge2 = Edge.new(0.25,nil,iNode2)
iEdge3 = Edge.new(-0.5,nil,iNode3)

iNode1.addEdge(iEdge1)
iNode2.addEdge(iEdge2)
iNode3.addEdge(iEdge3)

# Add to network...
theNetwork.layers[0].addNode(iNode1)
theNetwork.layers[0].addNode(iNode2)
theNetwork.layers[0].addNode(iNode3)




# Run
theNetwork.run