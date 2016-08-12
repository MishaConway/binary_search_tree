# binary_search_tree

[![Gem Version](http://img.shields.io/gem/v/binary_search_tree.svg)](https://rubygems.org/gems/binary_search_tree)

This gem implements the two classes BinarySearchTree and BinarySearchTreeHash. BinarySearchTree is a self balancing avl tree.

Most people will only need to be concerned with BinarySearchTreeHash as it is a wrapper over BinarySearchTree that provides the same interface as the native Ruby hash. This class is useful when you want a container that provides fast lookups with minimal memory footprint. Since it is self balancing, it will reorganize itself on every new insert to make subsequent lookups optimal.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'binary_search_tree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install binary_search_tree

## Usage

### Example usage of BinarySearchTreeHash

```
ruby-1.9.2> h = BinarySearchTreeHash.new logger     (note: passing a logger is optional)
 => {}
ruby-1.9.2> (1..100).each{|i| h[i] = i*1000}
ruby-1.9.2> h[45]
  DEBUG - [03/May/2011 15:02:07] "find operation completed in 7 lookups..."
 => 45000
ruby-1.9.2> h[77]
  DEBUG - [03/May/2011 15:02:14] "find operation completed in 6 lookups..."
 => 77000
ruby-1.9.2> h[32]
  DEBUG - [03/May/2011 15:02:18] "find operation completed in 2 lookups..."
 => 32000
ruby-1.9.2> h.delete 32
  DEBUG - [03/May/2011 15:02:29] "find operation completed in 2 lookups..."
ruby-1.9.2> h[32]
  DEBUG - [03/May/2011 15:02:58] "find operation completed in 8 lookups..."
 => nil
ruby-1.9.2> h[5000] = 7777
 => 7777
ruby-1.9.2> h[5000]
  DEBUG - [03/May/2011 15:03:33] "find operation completed in 7 lookups..."
 => 7777
ruby-1.9.2> h.size
 => 100
ruby-1.9.2> h.delete 50
  DEBUG - [03/May/2011 15:03:48] "find operation completed in 6 lookups..."
ruby-1.9.2> h.size
 => 99
```

### Example usage of BinarySearchTree (only use this if you want something lower level)

```
ruby-1.9.2> b = BinarySearchTree.new logger   (note: passing a logger is optional)
ruby-1.9.2> b.insert 45, 78
ruby-1.9.2> b.insert 23, 5
ruby-1.9.2> b.insert 77, 999
ruby-1.9.2> b.insert 43, 999
ruby-1.9.2> b.find(23).value
  DEBUG - [03/May/2011 15:23:15] "find operation completed in 2 lookups..."
 => 5
ruby-1.9.2> b.find(24)
  DEBUG - [03/May/2011 15:23:32] "find operation completed in 4 lookups..."
 => nil
ruby-1.9.2> b.find(43).value
  DEBUG - [03/May/2011 15:23:40] "find operation completed in 3 lookups..."
 => 999
ruby-1.9.2> b.max.value
 => 999
ruby-1.9.2> b.min.value
 => 5
ruby-1.9.2> b.size
 => 4
ruby-1.9.2> b.remove 23
  DEBUG - [03/May/2011 15:24:41] "find operation completed in 2 lookups..."
ruby-1.9.2> b.size
 => 3
ruby-1.9.2> b.clear
 => 0
ruby-1.9.2> b.size
 => 0
```

## Contributing

1. Fork it ( https://github.com/MishaConway/binary_search_tree/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
