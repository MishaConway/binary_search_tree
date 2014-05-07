require 'rspec'
require 'binary_search_tree'

describe BinarySearchTree do
  subject(:tree) { BinarySearchTree.new() }

  before(:each) do
    tree.insert(9, "nine")
    tree.insert(5, "five")
    tree.insert(10, "ten")
  end

  describe "#find" do
    it "finds a value when a value is present" do
      expect(tree.find(9).value ).to eql("nine")
    end
  end

  describe "#min" do
    it "finds the minimum value" do
      expect(tree.min.key).to eql(5)
    end

    it "finds the minimum value" do
      tree.insert(2, "two")
      expect(tree.min.key).to eql(2)
    end

    it "finds the maximum value" do
      expect(tree.max.key).to eql(10)
    end
  end

  describe "#max" do
    it "returns the maximum value" do
      expect(tree.max.key).to eql(10)
    end
  end

  describe "#remove_min" do
    it "updates the minimum value after removing" do
      expect(tree.min.key).to eql(5)
      tree.remove_min
      expect(tree.min.key).to eql(9)
    end
  end

  describe "#remove" do
    it "updates the number of nodes in the tree" do
      tree.remove(5)
      expect(tree.min.key).to eql(9)
    end
  end

  describe "#nodes" do
    it "returns an array of nodes" do
      expect(tree.nodes).to be_an(Array)
      expect(tree.nodes[0]).to be_a(BinaryNode)
    end

    it "contains all the nodes that have been inserted" do
       tree.nodes.count.should eql(3)
       tree.insert(1, "one")
       tree.nodes.count.should eql(4)
    end
  end




end

