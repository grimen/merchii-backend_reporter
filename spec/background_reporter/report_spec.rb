require 'spec_helper'

describe Merchii::BackgroundReporter::Report do

  before(:each) do
    Fog.mock! unless ENV['AWS_ACCESS_KEY']

    @key = "some-reporter-key"
    @report = Merchii::BackgroundReporter::Report.new(@key, {
        :aws_access_key_id => ENV['AWS_ACCESS_KEY'] || 'mocked',
        :aws_secret_access_key => ENV['AWS_ACCESS_SECRET'] || 'mocked',
        :key => 'test'
      })
  end

  describe "#as" do
    it { @report.must_respond_to :as }
    it { @report.must_respond_to :reporter }

    it "(): should give blank as reporter, and return it (@reporter)" do
      skip
      @report.instance_variable_set(:@reporter, :mean_machine)
      reporter = @report.as
      reporter.must_equal :mean_machine
    end

    it "('a_string'): should give :a_string as reporter , and return self (<#Report>)" do
      skip
      reporter = @report.as('a_string')
      reporter.must_equal :a_string
    end

    it "(:a_symbol): should give :a_symbol as reporter , and return self (<#Report>)" do
      skip
      reporter = @report.as(:a_symbol)
      reporter.must_equal :a_symbol
    end

    it "(nil): should raise ArgumentError" do
      skip
      lambda {
        reporter = @report.as(nil)
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(''): should raise ArgumentError" do
      skip
      lambda {
        reporter = @report.as('')
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(' '): should raise ArgumentError" do
      skip
      lambda {
        reporter = @report.as(' ')
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(:''): should raise ArgumentError" do
      skip
      lambda {
        reporter = @report.as(:'')
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(:' '): should raise ArgumentError" do
      skip
      lambda {
        reporter = @report.as(:' ')
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(<neither of String/Symbol/Nilclass>): should raise ArgumentError" do
      skip
      [Object.new].each do |object|
        lambda {
          reporter = @report.as(object)
        }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
      end
    end
  end

  describe "#get" do
    it { @report.must_respond_to :get }

    # REVIEW: Return "everything"?
    it "(): should raise ArgumentError" do
      skip
      lambda {
        data = @report.as(:mean_machine).get()
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(nil): should raise ArgumentError" do
      skip
      lambda {
        data = @report.as(:mean_machine).get(nil)
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "('key'): should return pushed data by the current reporter" do
      skip
      @report.adapter[:mean_machine] = {:foo => :bar}
      data = @report.as(:mean_machine).get
      data.must_equal({'foo' => 'bar'})
    end

    it "(:key): should return pushed data by the current reporter" do
      skip
    end
  end

  describe "#push" do
    it { @report.must_respond_to :push }

    it "(): should raise ArgumentError" do
      # TODO: Mock @report.adapter
      lambda {
        result = @report.as(:mean_machine).push()
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(nil): should raise ArgumentError" do
      # TODO: Mock @report.adapter
      lambda {
        result = @report.as(:mean_machine).push(nil)
      }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
    end

    it "(<other non-Hash objects>): should raise ArgumentError" do
      # TODO: Mock @report.adapter
      [Object.new, 'string', :symbol, ['array']].each do |data|
        lambda {
          result = @report.as(:mean_machine).push(data)
        }.must_raise Merchii::BackgroundReporter::Report::ArgumentError
      end
    end

    it "({}): should push specified data for this report as current reporter" do
      # TODO: Mock @report.adapter
      result = @report.as(:mean_machine).push({})
    end

    it "({:foo => :foo, :bar => true}): should push specified data for this report as current reporter" do
      # TODO: Mock @report.adapter
      result = @report.as(:mean_machine).push({:foo => :foo, :bar => true})
    end

    it "({:foo => :foo, :bar => true}): should push specified data for this report as current reporter" do
      # TODO: Mock @report.adapter
      result = @report.as(:mean_machine).push({:foo => :foo, :bar => true})
    end
  end

  describe "#clear" do
    it { @report.must_respond_to :clear }

    it "(): should clear all report data for this report by current reporter" do
      @report.as(:mean_machine).push({:foo => :bar})
      @report.as(:mean_machine).get.must_equal({'foo' => 'bar'})
      @report.as(:mean_machine).clear
      @report.as(:mean_machine).get.must_equal({})
    end
  end

end