require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe WillFilter::ExporterController do
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

  describe "GET fields" do
    render_views

    it "returns successfully" do
      get :fields, :wf_model => "User"
      response.code.should eq("200")
    end

    it "returns a list of the right fields" do
      WillFilter::Filter.any_instance.stub(:export_fields).and_return(["jim", "henson"])
      get :fields, :wf_model => "User", :wf_export_format => "csv"
      response.code.should eq("200")

      response.body.should include("jim")
      response.body.should include("henson")
    end
  end

  describe "Export handles requests"
    %w(
      WillFilter::Exporter::CSV
      WillFilter::Exporter::JSON
      WillFilter::Exporter::XML
      WillFilter::Exporter::HTML
    ).each do |t|
      it "successfully handles #{t} requests" do
        t.constantize.any_instance.stub(:to_data).and_return("muppets")
        t.constantize.any_instance.stub(:options).and_return({:type => "text/plain"})

        get :export, :wf_model => "User", :wf_export_format => t, :wf_export_fields => "first_name"

        response.body.should eq("muppets")
        response.code.should eq("200")
      end
    end

  describe "CSV" do
    it "returns a CSV representation of the requested data" do
      get :export, :wf_model => "User", :wf_export_format => "WillFilter::Exporter::CSV", :wf_export_fields => "first_name"

      5.times do |i|
        response.body.should include("User #{i}")
      end
    end
  end

  describe "JSON" do
    it "returns a JSON representation of the requested data" do
      get :export, :wf_model => "User", :wf_export_format => "WillFilter::Exporter::JSON", :wf_export_fields => "first_name"
      body = response.body.to_s
      result = JSON.parse(body)
      result.collect { |v| v["first_name"] }.should include("User 1")
    end
  end

  describe "Export XML" do
    it "returns an XML representation of the requested data" do
      get :export, :wf_model => "User", :wf_export_format => "WillFilter::Exporter::XML", :wf_export_fields => "first_name"
      result = Hash.from_xml(response.body)
    end
  end

  describe "Export HTML" do
    it "returns an HTML representation of the requested data" do
      get :export, :wf_model => "User", :wf_export_format => "WillFilter::Exporter::HTML", :wf_export_fields => "first_name"
      
      5.times do |i|
        response.body.should include("<td>User #{i}</td>")
      end
    end
  end

  describe "Handles custom formats" do
    it "returns the format created by our custom formatter" do
      class MuppetsExport < WillFilter::Exporter::JSON
        def to_data
          "muppets"
        end 
      end
      Object.const_set("MuppetsExport", MuppetsExport)
      WillFilter::Filter.any_instance.stub(:custom_formats).and_return(["MuppetsExport"])

      get :export, :wf_model => "User", :wf_export_format => "MuppetsExport", :wf_export_fields => "first_name"
      response.body.should eq("muppets")
      response.code.should eq("200")
    end

    it "Only allows filters from base, not other classes" do
      WillFilter::Filter.any_instance.stub(:custom_formats).and_return(["Kernel"])

      expect {
        get :export, :wf_model => "User", :wf_export_format => "Kernel", :wf_export_fields => "first_name"
      }.to raise_error(NoMethodError)
    end
  end
end
