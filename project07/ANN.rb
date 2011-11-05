class Network
  @layers = Array.new
  
  def initialize(layer_count)
    puts "Creating network..."
    for i in 0..layer_count
      puts "How many nodes do you want in this layer?"
      node_count = gets
      puts "Great. And what kind of layer is this?"
      layer_type = gets
      layer = Layer.new(node_count, layer_type)
      @layers.push(layer)
    end
  end
  
  def self.layers
    @layers
  end
  
  def self.run
    for i in 0..@layers.length
      thisLayer = @layers[i]
      for j in 0..thisLayer.length
        
  
end

class Layer
  @nodes = Array.new
  @name
  
  def initialize(node_count, layer_name)
    @name = layer_name
    puts "Creating layer..."
    for i in 0..node_count
      puts "What is the value of the node?"
      node_value = gets
      node = Node.new(node_value)
      @nodes.push(node)
    end
  end
  
  def self.nodes
    @nodes
  end
  
end

class Node
  @value
  @edges = Array.new
  
  def intialize(my_weight)
    @value = my_weight
  end
  
  def self.addEdge(edge)
    @edges.push(edge)
  end
  
  def self.value
    @value
  end
  
end

class Edge
  @weight
  
  def initialize(my_weight)
    @weight = my_weight
  end
  
  def self.weight
    @weight
  end
end

# Main
