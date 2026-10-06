require "./spec_helper"

describe Ipapi do
  client = Ipapi::Client.new

  it "#locate" do
    VCR.use_cassette("locate") do
      location = client.locate("8.8.8.8")

      location.ip.should eq("8.8.8.8")
      location.city.should eq("Mountain View")
      location.region.should eq("California")
      location.country.should eq("US")
      location.to_json.should be_a(String)
    end
  end

  it "#latlong" do
    VCR.use_cassette("latlong") do
      latlong = client.latlong("8.8.8.8")

      latlong.should eq("37.423010,-122.083352")
    end
  end
end
