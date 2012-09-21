module LearningRegistry
  require 'yajl/json_gem'
  require 'active_support/core_ext/hash'
  require 'active_support/core_ext/object'
  require 'active_model'
  require 'typhoeus'
  require 'cgi'
  require 'nokogiri'

  $LOAD_PATH.unshift(File.dirname(__FILE__))

  require "learning_registry/version"
  require "learning_registry/resource.rb"
  require "learning_registry/resource_data.rb"
  require "learning_registry/config.rb"
end
