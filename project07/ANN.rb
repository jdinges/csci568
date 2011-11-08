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
    for i in 1..@layers.length-1
      thisLayer = @layers[i]
      #puts "For layer #{thisLayer.name}: There are #{thisLayer.nodes.length} nodes"
      
      theseNodes = thisLayer.nodes
      
      for j in 0..theseNodes.length-1
        
        thisNode = theseNodes[j]
        theseEdges = thisNode.edges
        
        sum = 0;
        
        for k in 0..theseEdges.length-1
          
          thisEdge = theseEdges[k]
          #puts "\t#{sum} += #{thisEdge.weight * thisEdge.source.value}"
          sum += thisEdge.weight * thisEdge.source.value
          
        end
        
        #puts "\tNode #{j} new value = #{sum}"
        @layers[i].nodes[j].value = Math::tanh(sum)
        
        if i == @layers.length-1
          #puts "Node #{j+1} = #{@layers[i].nodes[j].value}"
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
  
  attr_accessor :value, :edges, :error
  
  def initialize(my_value)
    @value = my_value
    @edges = Array.new
    @error = 0
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

class Range
  def rand
    return self.begin + Kernel.rand(self.end-self.begin)
  end
end

N = 0.5

def dtanh(x)
  return 1.0 - x * x
end

def backpropegate(network, out1, out2, out3)
  
  # Load error terms in each node
  for i in (network.layers.length-1).downto(1)
    thisLayer = network.layers[i]
    #puts "Layer #{i+1}:"
    for j in 0..thisLayer.nodes.length-1
      theseEdges = thisLayer.nodes[j].edges
      for k in 0..theseEdges.length - 1
        # Adjust error on nodes
        thisEdge = theseEdges[k]
        source = thisEdge.source
        #puts"\tNode #{j+1} error = #{network.layers[i].nodes[j].edges[k].source.error += network.layers[i].nodes[j].edges[k].target.error * network.layers[i].nodes[j].edges[k].weight}"
        #--------------- Parent Node Error ------------- += --------------- This Node's Error -------------- * ----- Edge Connecting Two's Weight -------
        network.layers[i].nodes[j].edges[k].source.error += network.layers[i].nodes[j].edges[k].target.error * network.layers[i].nodes[j].edges[k].weight
      end
    end
  end
  
  # Adjust weights...
  for i in 1..network.layers.length-1
    for j in 0..network.layers[i].nodes.length - 1
      for k in 0..network.layers[i].nodes[j].edges.length - 1
        error = network.layers[i].nodes[j].edges[k].target.error
        prev = network.layers[i].nodes[j].edges[k].source.value

        network.layers[i].nodes[j].edges[k].weight += N * error * dtanh(prev)

      end
    end
  end
  
  return network
  
end

def train(network, out1, out2, out3)
  # First thing to do is compute what my output 
  # is given current set up.
  network.run
  
  node1r = network.layers[2].nodes[0].value
  node2r = network.layers[2].nodes[1].value
  node3r = network.layers[2].nodes[2].value
  
  acceptableError = 0.001
  
  #while ((node1r - out1).abs > acceptableError or 
    #(node2r - out2).abs > acceptableError or 
    #(node3r - out3).abs > acceptableError)
  for i in 0..9
    puts "\tnode1r = #{node1r}, node2r = #{node2r}, node3r = #{node3r}"
    
    network.layers[2].nodes[0].error = out1 - node1r
    network.layers[2].nodes[1].error = out2 - node2r
    network.layers[2].nodes[2].error = out3 - node3r
    
    newNetwork = backpropegate(network, out1, out2, out3)
    
    node1r = newNetwork.layers[2].nodes[0].value
    node2r = newNetwork.layers[2].nodes[1].value
    node3r = newNetwork.layers[2].nodes[2].value
    network = newNetwork
    
    puts "\tnode1r = #{node1r}, node2r = #{node2r}, node3r = #{node3r}"
    
  end
        
end
  

# Main
theNetwork = Network.new(3)

# Set up network layout

#----------------#
# Input layer... #
#----------------#

# Create nodes...
iNode1 = Node.new(1.0)
iNode2 = Node.new(0.25)
iNode3 = Node.new(-0.5)

# Add to network...
theNetwork.layers[0].addNode(iNode1)
theNetwork.layers[0].addNode(iNode2)
theNetwork.layers[0].addNode(iNode3)

#-----------------#
# Hidden layer... #
#-----------------#

# Create nodes...
hNode1 = Node.new(0)
hNode2 = Node.new(0)

# Creates edges
hEdge1_1 = Edge.new(2.0*rand-1, iNode1, hNode1)
hEdge1_2 = Edge.new(2.0*rand-1, iNode1, hNode2)

hEdge2_1 = Edge.new(2.0*rand-1, iNode2, hNode1)
hEdge2_2 = Edge.new(2.0*rand-1, iNode2, hNode2)

hEdge3_1 = Edge.new(2.0*rand-1, iNode3, hNode1)
hEdge3_2 = Edge.new(2.0*rand-1, iNode3, hNode2)

# Add edges to Nodes...
hNode1.addEdge(hEdge1_1)
hNode1.addEdge(hEdge2_1)
hNode1.addEdge(hEdge3_1)

hNode2.addEdge(hEdge1_2)
hNode2.addEdge(hEdge2_2)
hNode2.addEdge(hEdge3_2)

# Add to network
theNetwork.layers[1].addNode(hNode1)
theNetwork.layers[1].addNode(hNode2)

#-----------------#
# Output layer... #
#-----------------#

# Create nodes
oNode1 = Node.new(0)
oNode2 = Node.new(0)
oNode3 = Node.new(0)

#  Create edges
oEdge1_1 = Edge.new(2.0*rand-1, hNode1, oNode1)
oEdge1_2 = Edge.new(2.0*rand-1, hNode1, oNode2)
oEdge1_3 = Edge.new(2.0*rand-1, hNode1, oNode3)

oEdge2_1 = Edge.new(2.0*rand-1, hNode2, oNode1)
oEdge2_2 = Edge.new(2.0*rand-1, hNode2, oNode2)
oEdge2_3 = Edge.new(2.0*rand-1, hNode2, oNode3)

# Add edges to nodes...
oNode1.addEdge(oEdge1_1)
oNode1.addEdge(oEdge2_1)

oNode2.addEdge(oEdge1_2)
oNode2.addEdge(oEdge2_2)

oNode3.addEdge(oEdge1_3)
oNode3.addEdge(oEdge2_3)

# Add to network...
theNetwork.layers[2].addNode(oNode1)
theNetwork.layers[2].addNode(oNode2)
theNetwork.layers[2].addNode(oNode3)

# Run
theNetwork.run

# Training
train(theNetwork, 1.0, -1.0, 0.0)