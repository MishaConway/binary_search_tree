class BinarySearchTreeHash
  include Enumerable

  def initialize
    @bst = BinarySearchTree.new  
  end

  def clear
    @bst.clear
  end

  def empty?
    @bst.empty?
  end

  def [] key
    node = @bst.find key
    node.present?? node.value : nil
  end

  def []=(key, value)
    @bst.insert key, value
  end

  def delete key
    @bst.remove key
  end

  def to_hash
    h = {}
    each{ |key, value| h[key] = value }
    h
  end
  alias :to_h :to_hash

  def keys
    map{ |node| node.first }
  end

  def values
    map{ |node| node.second }    
  end

  def to_a
    map{ |node| [node.first, node.second] }
  end

  def to_s
    map{ |node| "#{node.first}#{node.second}" }.join
  end

  def min
    [@bst.min.key, @bst.min.value]
  end

  def max
    [@bst.max.key, @bst.max.value]    
  end

  def each
    @bst.nodes.each { |node| yield [node.key, node.value] }
  end

  def each_key
    @bst.nodes.each{ |node| yield node.key }
  end

  def each_value
    @bst.nodes.each{ |node| yield node.value }
  end

  def each_pair
    @bst.nodes.each{ |node| yield node.key, node.value }
  end

  def select
    @bst.nodes.select{ |node| yield node.key, node.value }.map{ |node| [node.key, node.value] }
  end

  def reject
    @bst.nodes.reject{ |node| yield node.key, node.value }.map{ |node| [node.key, node.value] }
  end

  def reject!
    changed = false
    nodes = @bst.nodes
    nodes.each_with_index do |node, i|
      if yield node.key, node.value
        changed = true
        @bst.remove node
        nodes[i] = nil
      end
    end
    changed ? nodes.compact.map{ |node| [node.key, node.value] } : nil 
  end

  def delete_if
    nodes = @bst.nodes
    nodes.each_with_index do |node, i|
      if yield node.key, node.value
        @bst.remove node
        nodes[i] = nil
      end
    end
    nodes.compact.map{ |node| [node.key, node.value] }
  end

  def size
    @bst.size
  end
  alias :length :size

  def has_key? key
    @bst.find(key).present?
  end

  def include? key
    has_key? key
  end

  def key? key
    has_key? key
  end

  def member? key
    has_key? key
  end

  def has_value? value
    @bst.find_value(value).present?  
  end

  def value? value
    has_value? value
  end

  def key value
    @bst.find_value(value).key
  end

  def values_at key, *extra_keys
    #TODO: optimize this so that only one tree traversal occurs
    ([key] + extra_keys).map{ |key| @bst.find(key).value }
  end

  def shift
    deleted_node = @bst.remove_min
    deleted_node.present?? [deleted_node.key, deleted_node.value] : nil
  end

  def invert
    inverted_bst_hash = BinarySearchTreeHash.new
    each{ |key, value| inverted_bst_hash[value] = key }
    inverted_bst_hash
  end

  def replace other_bst_hash
    clear
    merge! other_bst_hash
  end

  def merge other_bst_hash
    merged_hash = BinarySearchTreeHash.new
    each{ |key, value| merged_hash[key] = value}
    other_bst_hash.each{ |key, value| merged_hash[key] = value }
    merged_hash
  end

  def merge! other_bst_hash
    other_bst_hash.each{ |key, value| self[key] = value }
    self
  end

  def update other_bst_hash
    merge! other_bst_hash
  end

  def == other_bst_hash
    bst == other_bst_hash.send(:bst)
  end

private
  def bst
    @bst
  end
end