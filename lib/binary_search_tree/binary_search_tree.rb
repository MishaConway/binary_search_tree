class BinarySearchTree
  attr_reader :size, :root

  def balanced?
    if -1 == compute_and_check_height(@root)
      false
    else
      true
    end
  end

  def initialize logger=nil
    @logger = logger
    clear
  end

  def clear
    @root = nil
    @size = 0
  end

  def empty?
    @root.nil?
  end

  def find key
    @num_comparisons = 0
    node = locate key, @root
    @logger.debug "find operation completed in #{@num_comparisons} lookups..." if @logger
    node
  end

  def find_value value
    find_value_ex @root, value
  end

  def min
    @min ||= locate_min @root
  end

  def max
    @max ||= locate_max @root
  end

  def insert element, value
    put element, value, @root, nil
  end

  def remove node_or_key
    delete node_or_key
  end

  def remove_min
    delete min
  end

  def nodes
    @nodes = []
    serialize_nodes @root
    @nodes
  end

  def == other_bst
    compare @root, other_bst.root
  end

  private
  def invalidate_cached_values
    @min = @max = nil
  end

  def locate target, leaf
    @num_comparisons += 1
    if leaf.nil?
      return nil
    elsif leaf.key < target
      return locate target, leaf.right
    elsif leaf.key > target
      return locate target, leaf.left
    elsif leaf.key == target
      return leaf
    end
  end

  def locate_min leaf
    return nil if leaf.nil?
    return leaf if leaf.left.nil?
    return locate_min leaf.left
  end

  def locate_max leaf
    return nil if leaf.nil?
    return leaf if leaf.right.nil?
    return locate_max leaf.right
  end

  def recompute_heights start_from_node
    changed = true
    node = start_from_node
    while node && changed
      old_height = node.height
      if node.right || node.left
        node.height = node.max_children_height + 1
      else
        node.height = 0
      end
      changed = node.height != old_height
      node = node.parent
    end
  end

  def put element, value, leaf, parent, link_type=nil
    #once you reach a point where you can place a new node
    if leaf.nil?
      #create that new node
      leaf = BinaryNode.new element, value, parent
      @size += 1
      invalidate_cached_values
      if parent
        if 'left' == link_type
          parent.left = leaf
        else
          parent.right = leaf
        end
      else
        @root = leaf
      end
      if parent && parent.height.zero?
        #if it has a parent but it is balanced, move up
        node = parent
        node_to_rebalance = nil

        #continue moving up until you git the root
        while node
          node.height = node.max_children_height + 1
          if node.balance_factor.abs > 1
            node_to_rebalance = node
            break
          end
          node = node.parent
        end
        #if at any point you reach an unbalanced node, rebalance it
        rebalance node_to_rebalance if node_to_rebalance
      end

    elsif leaf.key < element
      put element, value, leaf.right, leaf, "right"
    elsif leaf.key > element
      put element, value, leaf.left, leaf, "left"
    elsif leaf.key == element
      leaf.value = value
    end
  end

  def find_value_ex leaf, value
    if leaf
      node_with_value = find_value_ex leaf.left, value
      return node_with_value if node_with_value
      return leaf if leaf.value == value
      node_with_value = find_value_ex leaf.right, value
      return node_with_value if node_with_value
    end
    nil
  end

  def serialize_nodes leaf
    unless leaf.nil?
      serialize_nodes leaf.left
      @nodes << leaf
      serialize_nodes leaf.right
    end
  end

  def compare leaf, other_bst_leaf
    if leaf && other_bst_leaf
        leaf.value == other_bst_leaf.value &&
        compare(leaf.left, other_bst_leaf.left) &&
        compare(leaf.right, other_bst_leaf.right)
    else
      leaf.nil? && other_bst_leaf.nil?
    end
  end

  def assert condition
    raise "assertion failed" unless condition
  end

  def rrc_rebalance a, f
    b = a.right
    c = b.right
    assert a && b && c
    a.right = b.left
    if a.right
      a.right.parent = a
    end
    b.left = a
    a.parent = b
    if f.nil?
      @root = b
      @root.parent = nil
    else
      if f.right == a
        f.right = b
      else
        f.left = b
      end
      b.parent = f
    end
    recompute_heights a
    recompute_heights b.parent
  end

  def rlc_rebalance a, f
    b = a.right
    c = b.left
    assert a && b && c
    b.left = c.right
    if b.left
      b.left.parent = b
    end
    a.right = c.left
    if a.right
      a.right.parent = a
    end
    c.right = b
    b.parent = c
    c.left = a
    a.parent = c
    if f.nil?
      @root = c
      @root.parent = nil
    else
      if f.right == a
        f.right = c
      else
        f.left = c
      end
      c.parent = f
    end
    recompute_heights a
    recompute_heights b
  end

  def llc_rebalance a, b, c, f
    assert a && b && c
    a.left = b.right
    if a.left
      a.left.parent = a
    end
    b.right = a
    a.parent = b
    if f.nil?
      @root = b
      @root.parent = nil
    else
      if f.right == a
        f.right = b
      else
        f.left = b
      end
      b.parent = f
    end
    recompute_heights a
    recompute_heights b.parent
  end

  def lrc_rebalance a, b, c, f
    assert a && b && c
    a.left = c.right
    if a.left
      a.left.parent = a
    end
    b.right = c.left
    if b.right
      b.right.parent = b
    end
    c.left = b
    b.parent = c
    c.right = a
    a.parent = c
    if f.nil?
      @root = c
      @root.parent = nil
    else
      if f.right == a
        f.right = c
      else
        f.left = c
      end
      c.parent = f
    end
    recompute_heights a
    recompute_heights b
  end

  def rebalance node_to_rebalance
    a = node_to_rebalance
    f = a.parent #allowed to be NULL
    if node_to_rebalance.balance_factor == -2
      if node_to_rebalance.right.balance_factor <= 0
        # """Rebalance, case RRC """
        rrc_rebalance a, f
      else
        rlc_rebalance a, f
        # """Rebalance, case RLC """
      end
    else
      assert node_to_rebalance.balance_factor == 2
      if node_to_rebalance.left.balance_factor >= 0
        b = a.left
        c = b.left
        # """Rebalance, case LLC """
        llc_rebalance a, b, c, f
      else
        b = a.left
        c = b.right
        #  """Rebalance, case LRC """
        lrc_rebalance a, b, c, f
      end
    end
  end

  def delete node_or_key
    if BinaryNode == node_or_key.class
      node = node_or_key
    else
      node = find node_or_key
    end

    if node
      @size -= 1
      invalidate_cached_values

      #     There are three cases:
      #
      #     1) The node is a leaf.  Remove it and return.
      #
      #     2) The node is a branch (has only 1 child). Make the pointer to this node
      #        point to the child of this node.
      #
      #     3) The node has two children. Swap items with the successor
      #        of the node (the smallest item in its right subtree) and
      #        delete the successor from the right subtree of the node.
      if node.is_leaf?
        remove_leaf node
      elsif (!!node.left) ^ (!!node.right)
        remove_branch node
      else
        assert node.left && node.right
        swap_with_successor_and_remove node
      end
    end
    node
  end

  def remove_leaf node
    parent = node.parent
    if parent
      if parent.left == node
        parent.left = nil
      else
        assert parent.right == node
        parent.right = nil
      end
      recompute_heights parent
    else
      @root = nil
    end
    #del node
    # rebalance
    node = parent
    while node
      rebalance node unless [-1, 0, 1].include? node.balance_factor
      node = node.parent
    end
  end




  def remove_branch node
      parent = node.parent
      if parent
        if parent.left == node
          parent.left = node.right || node.left
        else
            assert parent.right == node
            parent.right = node.right || node.left
        end
        if node.left
            node.left.parent = parent
        else
            assert node.right
            node.right.parent = parent
        end
        recompute_heights parent
      else
        if node.left
          @root = node.left
          node.left.parent = nil
        else
          @root = node.right
          node.right.parent = nil
        end
        recompute_heights @root
      end

      # rebalance
      node = parent
      while node
        rebalance node unless [-1,0,1].include? node.balance_factor
        node = node.parent
      end
  end

  def swap_with_successor_and_remove node
    successor = locate_min node.right
    swap_nodes node, successor
    assert node.left.nil?
    if node.height == 0
      remove_leaf node
    else
      remove_branch node
    end
  end

  def swap_nodes node1, node2
    assert node1.height > node2.height
    parent1 = node1.parent
    left_child1 = node1.left
    right_child1 = node1.right
    parent2 = node2.parent
    assert parent2
    assert parent2.left == node2 || parent2 == node1
    left_child2 = node2.left
    assert left_child2.nil?
    right_child2 = node2.right

    # swap heights
    tmp = node1.height
    node1.height = node2.height
    node2.height = tmp

    if parent1
      if parent1.left == node1
        parent1.left = node2
      else
        assert parent1.right == node1
        parent1.right = node2
      end
      node2.parent = parent1
    else
      @root = node2
      @root.parent = nil
    end

    node2.left = left_child1
    left_child1.parent = node2
    node1.left = left_child2 # None
    node1.right = right_child2
    if right_child2
      right_child2.parent = node1
    end
    if parent2 != node1
      node2.right = right_child1
      right_child1.parent = node2

      parent2.left = node1
      node1.parent = parent2
    else
      node2.right = node1
      node1.parent = node2
    end
  end

  def compute_and_check_height root
    return 0 if root.nil?
    left_sub_tree_height = compute_and_check_height root.left
    return -1 if -1 == left_sub_tree_height

    right_sub_tree_height = compute_and_check_height root.right
    return -1 if -1 == right_sub_tree_height

    height_difference = (left_sub_tree_height - right_sub_tree_height).abs;

    if height_difference > 1
      -1
    else
      [left_sub_tree_height, right_sub_tree_height].max + 1
    end
  end
end

