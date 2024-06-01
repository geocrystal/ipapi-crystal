# ipapi-crystal

[![Crystal CI](https://github.com/geocrystal/ipapi-crystal/actions/workflows/crystal.yml/badge.svg)](https://github.com/geocrystal/ipapi-crystal/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/geocrystal/ipapi-crystal.svg)](https://github.com/geocrystal/ipapi-crystal/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://geocrystal.github.io/ipapi-crystal/)
[![License](https://img.shields.io/github/license/geocrystal/ipapi-crystal.svg)](https://github.com/geocrystal/ipapi-crystal/blob/main/LICENSE)

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

location = client.locate("8.8.8.8")
# => #<Ipapi::Location:0x780aff839b40 @ip="8.8.8.8", @network="8.8.8.0/24", @version="IPv4", @city="Mountain View", @region="California", @region_code="CA", @country="US", @country_name="United States", @country_code="US", @country_code_iso3="USA", @country_capital="Washington", @country_tld=".us", @continent_code="NA", @in_eu=false, @postal="94043", @latitude=37.42301, @longitude=-122.083352, @timezone="America/Los_Angeles", @utc_offset="-0700", @country_calling_code="+1", @currency="USD", @currency_name="Dollar", @languages="en-US,es-US,haw,fr", @country_area=9629091.0, @country_population=327167434, @asn="AS15169", @org="GOOGLE">

location.ip                   # "8.8.8.8"
location.network              # "8.8.8.0/24"
location.version              # "IPv4"
location.city                 # "Mountain View"
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
location.latitude             # 37.42301
location.longitude            # -122.083352
location.timezone             # "America/Los_Angeles"
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
