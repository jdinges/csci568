class Network
  
  @layers = Array.new
  
  def initialize(layer_count)
    puts "Creating network..."
    for i in 0..layer_count-1
      puts "What do you want this layer to be called?"
      layer_type = gets
      layer = Layer.new(layer_type)
      @layers.push(layer)
    end
  end
  
  def self.layers
    @layers
  end
  
  def self.run
    for i in 0..@layers.length-1
      
      thisLayer = @layers[i]
      theseNodes = thisLayer.nodes
      
      for j in 0..theseNodes.length-1
        
        thisNode = theseNode[j]
        theseEdges = thisNode.edges
        
        sum = 0;
        
        for k in 0..theseEdges.length-1
          
          thisEdge = theseEdges[k]
          sum += thisEdge * thisNode.value
          
        end
        
        thisNode.value = sum
        
        if i == @layers.length-1
          puts "Node #{j} = #{thisNode.value}"
        
      end
      
    end
    
  end
      
  
end

class Layer
  
  attr_accessor :name
  @nodes = Array.new
  
  def initialize(layer_name)
    @name = layer_name
  end
  
  def self.addNode(node)
    @nodes.push(node)
  end
  
  def self.nodes
    @nodes
  end
  
end

class Node
  
  attr_accessor :value
  @edges = Array.new
  
  def intialize(my_weight)
    @value = my_weight
  end
  
  def self.addEdge(edge)
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
