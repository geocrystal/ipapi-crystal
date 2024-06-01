require "./spec_helper"

describe Ipapi do
  client = Ipapi::Client.new

  it "#locate" do
    location = client.locate("8.8.8.8")

    location.ip.should eq("8.8.8.8")
    location.city.should eq("Mountain View")
    location.region.should eq("California")
    location.country.should eq("US")
  end

  it "#latlong" do
    latlong = client.latlong("8.8.8.8")

    latlong.should eq("37.423010,-122.083352")
  end
end
