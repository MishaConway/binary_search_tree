require 'rspec'
require 'binary_search_tree'

describe BinaryNode do
  subject(:node) { BinaryNode.new(5, 'five', nil) }
  # its(:key) { should be (5) }
  # its(:value) { should eql ("five") }

  describe '#leaf?' do
    it 'returns true when height is 0' do
      expect(node.leaf?).to be true
    end

    it 'returns false when height is not 0' do
      node.height = 1
      expect(node.leaf?).to be false
    end
  end

  describe '#max_children_height' do
    before(:each) do
      @left = double('left_child', present?: true, height: 3)
      @right = double('right_child', present?: true, height: 2)
      node.left = @left
      node.right = @right
    end

    context 'when both children are present and left has a greater height' do
      it "returns the value of the left child's height" do
        expect(node.max_children_height).to eql(3)
      end
    end

    context 'when both children are present and right has a greater height' do
      it "returns the value of the right child's height" do
        @right.stub(:height).and_return(4)
        expect(node.max_children_height).to eql(4)
      end
    end

    context 'when only the left child is present' do
      it "returns the value of the left child's height" do
        node.right = nil

        expect(node.max_children_height).to eql(3)
      end
    end

    context 'when only the right child is present' do
      it "returns the value of the right child's height" do
        node.left = nil
        expect(node.max_children_height).to eql(2)
      end
    end
  end

  describe '#balance_factor' do
    before(:each) do
      @left = double('left_child', present?: true, height: 3)
      @right = double('right_child', present?: true, height: 2)
      node.left = @left
      node.right = @right
    end

    it 'returns the correct height when the left is greater' do
      expect(node.balance_factor).to eql(1)
    end

    it 'returns the correct height when the right is greater' do
      @right.stub(:height).and_return(5)
      expect(node.balance_factor).to eql(-2)
    end

    it 'returns the correct height when both are zero' do
      @right.stub(:height).and_return(0)
      @left.stub(:height).and_return(0)
      expect(node.balance_factor).to eql(0)
    end
  end
end
