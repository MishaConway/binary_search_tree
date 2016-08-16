# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'binary_search_tree/version'

Gem::Specification.new do |s|
  s.name = 'binary_search_tree'
  s.version = BinarySearch::VERSION

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version= # rubocop:disable Metrics/LineLength
  s.require_paths = ['lib']
  s.authors = ['Misha Conway']
  s.email = 'MishaAConway@gmail.com'
  s.files = `git ls-files -z`.split("\x0")
  s.licenses = ['MIT']
  s.rubyforge_project = 'nowarning'
  s.rubygems_version = '2.4.5'
  s.summary = %w(A self balancing avl binary search tree class. Also includes
                 BinarySearchTreeHash which is a hash like class that
                 internally uses binary search tree.).join(' ')

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
