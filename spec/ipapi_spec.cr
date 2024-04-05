require "./spec_helper"

describe Ipapi do
  client = Ipapi::Client.new

  it "#locate" do
    location = client.locate("50.1.2.3")

    location.ip.should eq("50.1.2.3")
    location.city.should eq("Antelope")
    location.region.should eq("California")
    location.country.should eq("US")
  end

  it "#latlong" do
    latlong = client.latlong("50.1.2.3")

    latlong.should eq("38.716900,-121.367700")
  end
end
