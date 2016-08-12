class BinarySearchTreeHash
  include Enumerable

  def initialize(logger = nil)
    @bst = BinarySearchTree.new logger
  end

  def clear
    @bst.clear
    self
  end

  def empty?
    @bst.empty?
  end

  def [](key)
    node = @bst.find key
    node.nil? ? nil : node.value
  end

  def []=(key, value)
    @bst.insert key, value
  end

  def delete(key)
    @bst.remove key
    self
  end

  def to_hash
    h = {}
    each { |key, value| h[key] = value }
    h
  end
  alias to_h to_hash

  def keys
    map(&:first)
  end

  def values
    map(&:last)
  end

  def to_a
    map { |node| [node.first, node.last] }
  end

  def to_s
    '{' + map { |node| "#{node.first} => #{node.last}" }.join(', ') + '}'
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
    @bst.nodes.each { |node| yield node.key }
  end

  def each_value
    @bst.nodes.each { |node| yield node.value }
  end

  def each_pair
    @bst.nodes.each { |node| yield node.key, node.value }
  end

  def select
    @bst.nodes.select { |node| yield node.key, node.value }.map { |node| [node.key, node.value] } # rubocop:disable Metrics/LineLength
  end

  def reject
    @bst.nodes.reject { |node| yield node.key, node.value }.map { |node| [node.key, node.value] } # rubocop:disable Metrics/LineLength
  end

  def reject!
    changed = false
    nodes = @bst.nodes
    nodes.each_with_index do |node, i|
      if yield node.key, node.value # rubocop:disable Style/Next:
        changed = true
        @bst.remove node
        nodes[i] = nil
      end
    end
    changed ? nodes.compact.map { |node| [node.key, node.value] } : nil
  end

  def delete_if
    nodes = @bst.nodes
    nodes.each_with_index do |node, i|
      if yield node.key, node.value
        @bst.remove node
        nodes[i] = nil
      end
    end
    nodes.compact.map { |node| [node.key, node.value] }
  end

  def size
    @bst.size
  end
  alias length size

  def key?(key)
    !!@bst.find(key)
  end
  alias has_key? key?

  def include?(key)
    key? key
  end

  def member?(key)
    key? key
  end

  def value?(value)
    !!@bst.find_value(value)
  end
  alias has_value? value?

  def key(value)
    @bst.find_value(value).key
  end

  def values_at(key, *extra_keys)
    # TODO: optimize this so that only one tree traversal occurs
    ([key] + extra_keys).map { |k| @bst.find(k).value }
  end

  def shift
    deleted_node = @bst.remove_min
    deleted_node.nil? ? nil : [deleted_node.key, deleted_node.value]
  end

  def invert
    inverted_bst_hash = BinarySearchTreeHash.new
    each { |key, value| inverted_bst_hash[value] = key }
    inverted_bst_hash
  end

  def replace(other_bst_hash)
    clear
    merge! other_bst_hash
  end

  def merge(other_bst_hash)
    merged_hash = BinarySearchTreeHash.new
    each { |key, value| merged_hash[key] = value }
    other_bst_hash.each { |key, value| merged_hash[key] = value }
    merged_hash
  end

  def merge!(other_bst_hash)
    other_bst_hash.each { |key, value| self[key] = value }
    self
  end

  def update(other_bst_hash)
    merge! other_bst_hash
  end

  def ==(other)
    bst == other.send(:bst)
  end

  private

  attr_reader :bst
end
