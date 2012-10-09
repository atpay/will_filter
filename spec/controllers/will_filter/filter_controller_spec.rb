require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe WillFilter::FilterController do
  describe "Unsaved filters" do
    it "loads results from show" do
      get :show
      response.code.should eq("200")
    end

    it "saves a filter that was once unsaved" do

    end

    it "updates condition" do

    end

    it "removes condition" do

    end

    it "removes all conditions" do

    end

    it "loads a filter" do

    end
  end

  describe "Saved filters" do

  end


  before :all do
    5.times do |i|
      User.create :first_name => "User #{i}"
    end
  end

  after :all do
    User.delete_all
  end

  describe "GET index" do
    it "returns successfully" do
      get :index
      response.code.should eq("200")
    end
  end
