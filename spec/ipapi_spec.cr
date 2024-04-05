require "./spec_helper"

describe Ipapi do
  it "#locate" do
    client = Ipapi::Client.new

    location = client.locate("50.1.2.3")

    location.ip.should eq("50.1.2.3")
    location.city.should eq("Antelope")
    location.region.should eq("California")
    location.country.should eq("US")
  end
end
