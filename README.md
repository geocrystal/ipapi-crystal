# ipapi-crystal

Crystal bindings for <https://ipapi.co> (IP Address Location & Geolocation API)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ipapi:
       github: geocrystal/ipapi-crystal
   ```

2. Run `shards install`

## Usage

```crystal
require "ipapi"

client = Ipapi::Client.new

location = client.locate("50.1.2.3")
# => #<Ipapi::Location:0x7b45cdce5b40 @ip="50.1.2.3", @network="50.1.0.0/21", @version="IPv4", @city="Antelope", @region="California", @region_code="CA", @country="US", @country_name="United States", @country_code="US", @country_code_iso3="USA", @country_capital="Washington", @country_tld=".us", @continent_code="NA", @in_eu=false, @postal="95843", @latitude=38.7169, @longitude=-121.3677, @timezone="America/Los_Angeles", @utc_offset="-0700", @country_calling_code="+1", @currency="USD", @currency_name="Dollar", @languages="en-US,es-US
,haw,fr", @country_area=9629091.0, @country_population=327167434, @asn="AS7065", @org="SNIC">

location.ip                   # "50.1.2.3"
location.network              # "50.1.0.0/21"
location.version              # "IPv4"
location.city                 # "Antelope"
location.region               # "California"
location.region_code          # "CA"
location.country              # "US"
location.country_name         # "United States"
location.country_code         # "US"
location.country_code_iso3    # "USA"
location.country_capital      # "Washington"
location.country_tld          # ".us"
location.continent_code       # "NA"
location.in_eu                # false
location.postal               # "95843"
location.latitude             # 38.7169
location.longitude            # -121.3677
timezone                      # "America/Los_Angeles"
location.utc_offset           # "-0700"
location.country_calling_code # "+1"
location.currency             # "USD"
location.currency_name        # "Dollar"
location.languages            # "en-US,es-US,haw,fr"
location.country_area         # 9629091.0
location.country_population   # 327167434
location.asn                  # "AS7065"
location.org                  # "SNIC"
```

## Contributing

1. Fork it (<https://github.com/geocrystal/ipapi-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
