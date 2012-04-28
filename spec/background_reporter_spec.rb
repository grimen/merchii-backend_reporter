require 'spec_helper'

describe Merchii::BackgroundReporter do

  before(:each) do
    ::Fog.mock!
    # REVIEW: these have to set before reporter is loaded, moved to spec_helper - jaakko
    # ENV['AWS_ACCESS_KEY'] ||= 'mocked'
    # ENV['AWS_ACCESS_SECRET'] ||= 'mocked'
  end

  describe "#report" do
    it { Merchii::BackgroundReporter.must_respond_to :report }

    it "(): should raise ArgumentError" do
      lambda {
        report = Merchii::BackgroundReporter.report()
      }.must_raise Merchii::BackgroundReporter::ArgumentError
    end

    it "(nil): should raise ArgumentError" do
      lambda {
        report = Merchii::BackgroundReporter.report(nil)
      }.must_raise Merchii::BackgroundReporter::ArgumentError
    end

    it "(''): should raise ArgumentError" do
      lambda {
        report = Merchii::BackgroundReporter.report('')
      }.must_raise Merchii::BackgroundReporter::ArgumentError
    end

    it "(' '): should raise ArgumentError" do
      lambda {
        report = Merchii::BackgroundReporter.report(' ')
      }.must_raise Merchii::BackgroundReporter::ArgumentError
    end

    it "(:''): should raise ArgumentError" do
      lambda {
        report = Merchii::BackgroundReporter.report(:'')
      }.must_raise Merchii::BackgroundReporter::ArgumentError
    end

    it "(:' '): should raise ArgumentError" do
      lambda {
        report = Merchii::BackgroundReporter.report(:' ')
      }.must_raise Merchii::BackgroundReporter::ArgumentError
    end

    it "('my_report'): should return new Report instance with key/id 'my_report'" do
      new_report = Merchii::BackgroundReporter::Report.new('my_report')
      Merchii::BackgroundReporter::Report.expects(:new).with('my_report', {}).returns(new_report)
      report = Merchii::BackgroundReporter.report('my_report')
    end

    it "(:my_report): should return new Report instance with key/id 'my_report'" do
      new_report = Merchii::BackgroundReporter::Report.new(:my_report)
      Merchii::BackgroundReporter::Report.expects(:new).with(:my_report, {}).returns(new_report)
      report = Merchii::BackgroundReporter.report(:my_report)
    end

  end

end