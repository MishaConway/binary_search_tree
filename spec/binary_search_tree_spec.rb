require 'rspec'
require 'binary_search_tree'

describe BinarySearchTree do
  subject(:tree) { BinarySearchTree.new }

  before(:each) do
    tree.insert(9, 'nine')
    tree.insert(5, 'five')
    tree.insert(10, 'ten')
  end

  describe '#insert' do
    it 'remains balanced after insertion requiring an lrc rebalance' do
      tree.insert(1, 'one')
      tree.insert(3, 'three')
      expect(tree.root.max_children_height).to eql(1)
    end

    it 'remains balanced after insertion requiring an llc rebalance' do
      tree.insert(1, 'one')
      tree.insert(0.5, 'half')
      expect(tree.root.max_children_height).to eql(1)
    end

    it 'remains balanced after insertion requiring an rrc rebalance' do
      tree.insert(11, 'eleven')
      tree.insert(12, 'twelve')
      expect(tree.root.max_children_height).to eql(1)
    end

    it 'remains balanced after insertion requiring an rlc rebalance' do
      tree.insert(15, 'X')
      tree.insert(14, 'X')
      expect(tree.root.max_children_height).to eql(1)
    end
  end

  describe '#find' do
    it 'finds a value when a value is present' do
      expect(tree.find(9).value).to eql('nine')
    end

    it 'does not find a value that is not present' do
      expect(tree.find(18)).to eql(nil)
    end
  end

  describe '#min' do
    it 'finds the minimum value' do
      expect(tree.min.key).to eql(5)
    end

    it 'finds the minimum value after insert' do
      tree.insert(0.5, 'half')
      expect(tree.min.key).to eql(0.5)
    end
  end

  describe '#max' do
    it 'returns the maximum value' do
      expect(tree.max.key).to eql(10)
    end
  end

  describe '#remove_min' do
    it 'updates the minimum value after removing' do
      expect(tree.min.key).to eql(5)
      tree.remove_min
      expect(tree.min.key).to eql(9)
    end
  end

  describe '#remove' do
    it 'updates the number of nodes in the tree' do
      tree.remove(5)
      expect(tree.min.key).to eql(9)
    end

    it "doesn't corrupt tree" do
      tree.remove 10
      expect(tree.balanced?).to eql(true)
      expect(tree.nodes.size).to eql(tree.size)

      tree.remove 9
      expect(tree.balanced?).to eql(true)
      expect(tree.nodes.size).to eql(tree.size)
    end
  end

  describe '#nodes' do
    it 'returns an array of nodes' do
      expect(tree.nodes).to be_an(Array)
      expect(tree.nodes[0]).to be_a(BinaryNode)
    end

    it 'contains all the nodes that have been inserted' do
      expect(tree.nodes.count).to eql(3)
      tree.insert(11, 'eleven')
      expect(tree.nodes.count).to eql(4)
    end
  end
end
