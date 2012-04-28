require 'spec_helper'

describe Merchii::BackgroundReporter::Adapters::S3 do
  let(:aws_options){
    {
      :aws_access_key_id => ENV['AWS_ACCESS_KEY'] || 'mocked',
      :aws_secret_access_key => ENV['AWS_ACCESS_SECRET'] || 'mocked',
      :region => 'eu-west-1'
    }
  }

  let(:adapter_options) {
    aws_options.merge( {:key => 'test'} )
  }

  let(:s3) do
    ::Fog::Storage::AWS.new(aws_options)
  end

  before(:each) do
    Fog.mock! # unless ENV['AWS_ACCESS_KEY']
    @store = Merchii::BackgroundReporter::Adapters::S3.new(adapter_options)
    @store.clear
  end

  describe "directory" do
    it "should create new directory if it doesn't exists" do
      @store.send(:get_directory, s3, adapter_options[:key]).key.must_equal s3.directories.first.key
    end

    it "should return list of directories" do
      @store.send(:list_directories, s3).map(&:key).must_equal s3.directories.map(&:key)
    end

    it "should create new directory" do
      skip
      # Review: Find correct way to create expect for s3 directories.create, current is failing - jaakko
      ::Fog::Storage::AWS.any_instance.directories.expects(:create).with({:key => 'test', :public => false})
      @store.send(:create_directory, s3, 'test')
    end
  end

  types = {
    'Object' => [{:foo => :bar}, {:bar => :baz}]
  }

  types.each do |type, (key, key2)|
    it "reads from keys that are #{type}s like a Hash" do
      @store[key].must_equal nil
    end

    it "writes String values to keys that are #{type}s like a Hash" do
      @store[key] = "value"
      @store[key].must_equal "value"
    end

    # it "guarantees that a different String value is retrieved from the #{type} key" do
    #   value = "value"
    #   @store[key] = value
    #   @store[key].wont_equal(value)
    # end

    it "writes Object values to keys that are #{type}s like a Hash" do
      @store[key] = {:foo => :bar}
      @store[key].must_equal({'foo' => 'bar'})
    end

    it "guarantees that a different Object value is retrieved from the #{type} key" do
      value = {:foo => :bar}
      @store[key] = value
      @store[key].wont_equal(value)
    end

    it "returns false from key? if a #{type} key is not available" do
      @store.key?(key).must_equal false
    end

    it "returns true from key? if a #{type} key is available" do
      @store[key] = "value"
      @store.key?(key).must_equal true
    end

    it "removes and returns an element with a #{type} key from the backing store via delete if it exists" do
      @store[key] = "value"
      @store.delete(key).must_equal "value"
      @store.key?(key).must_equal false
    end

    it "returns nil from delete if an element for a #{type} key does not exist" do
      @store.delete(key).must_equal nil
    end

    it "removes all #{type} keys from the store with clear" do
      @store[key] = "value"
      @store[key2] = "value2"
      @store.clear
      @store.key?(key).wont_equal true
      @store.key?(key2).wont_equal true
    end

    it "fetches a #{type} key with a default value with fetch, if the key is not available" do
      @store.fetch(key, "value").must_equal "value"
    end

    it "fetches a #{type} key with a block with fetch, if the key is not available" do
      @store.fetch(key) { |k| "value" }.must_equal "value"
    end

    it "does not run the block if the #{type} key is available" do
      @store[key] = "value"
      unaltered = "unaltered"
      @store.fetch(key) { unaltered = "altered" }
      unaltered.must_equal "unaltered"
    end

    it "fetches a #{type} key with a default value with fetch, if the key is available" do
      @store[key] = "value2"
      @store.fetch(key, "value").must_equal "value2"
    end

    it "stores #{key} values with #store" do
      @store.store(key, "value")
      @store[key].must_equal "value"
    end
  end

end