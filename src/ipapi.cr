require "http/client"
require "json"

# Crystal bindings for https://ipapi.co (IP Address Location & Geolocation API)
#
# API Docs : https://ipapi.co/api/
module Ipapi
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  API_URL = "https://ipapi.co/"

  # https://ipapi.co/api/#specific-location-field
  FIELDS = {
    "ip"                   => "public (external) IP address (same as URL `ip`)",
    "city"                 => "city name",
    "region"               => "region name (administrative division)",
    "region_code"          => "region code",
    "country"              => "country code (2 letter, ISO 3166-1 alpha-2)",
    "country_code"         => "country code (2 letter, ISO 3166-1 alpha-2)",
    "country_code_iso3"    => "country code (3 letter, ISO 3166-1 alpha-3)",
    "country_name"         => "short country name",
    "country_capital"      => "capital of the country",
    "country_tld"          => "country specific TLD (top-level domain)",
    "country_area"         => "area of the country (in sq km)",
    "country_population"   => "population of the country",
    "continent_code"       => "country code (2 letter, ISO 3166-1 alpha-2)",
    "in_eu"                => "whether IP address belongs to a country that is a member of the European Union (EU)",
    "postal"               => "postal code / zip code",
    "latitude"             => "latitude",
    "longitude"            => "longitude",
    "latlong"              => "comma separated latitude and longitude",
    "timezone"             => "timezone (IANA format i.e. “Area/Location”)",
    "utc_offset"           => "UTC offset (with daylight saving time) as `+HHMM` or `-HHMM` (`HH` is hours, `MM` is minutes)",
    "country_calling_code" => "country calling code (dial in code, comma separated)",
    "currency"             => "currency code (ISO 4217)",
    "currency_name"        => "currency name",
    "languages"            => "languages spoken (comma separated 2 or 3 letter ISO 639 code with optional hyphen separated country suffix)",
    "asn"                  => "autonomous system number",
    "org"                  => "organization name",
  }

  class Client
    def initialize(@api_key : String? = nil)
    end

    # Retrive the location of a specific IP address.
    # If `ip_address` is `nil`, use the client's IP.
    def locate(ip_address : String? = nil) : Location?
      url = Path.posix([API_URL, ip_address, "json"].compact).to_s
      url = url + "?access_key=#{@api_key}" if @api_key

      response = HTTP::Client.get(url)

      parse_locate_response(response)
    end

    {% for field, description in FIELDS %}
      # Retrive {{description.id}} of a specific IP address.
      # If `ip_address` is `nil`, use the client's IP.
      def {{field.id}}(ip_address : String? = nil) : String
        url = Path.posix([API_URL, ip_address, "{{field.id}}"].compact).to_s

        url = url + "?access_key=#{@api_key}" if @api_key

        response = HTTP::Client.get(url)

        parse_field_response(response)
      end
    {% end %}

    private def parse_locate_response(response : HTTP::Client::Response) : Location?
      case response.status_code
      when 200
        if JSON.parse(response.body).as_h["error"]? == true
          error_response = ErrorResponse.from_json(response.body)

          raise Error.new(error_response.reason)
        end

        Location.from_json(response.body)
      when 403
        raise AuthorizationFailedException.new
      when 404
        raise PageNotFoundException.new
      when 429
        raise RateLimitedException.new
      else
        raise Error.new(response.body)
      end
    end

    private def parse_field_response(response : HTTP::Client::Response) : String
      case response.status_code
      when 200
        response.body
      when 403
        raise AuthorizationFailedException.new
      when 404
        raise PageNotFoundException.new
      when 429
        raise RateLimitedException.new
      else
        raise Error.new(response.body)
      end
    end
  end

  # Generic error.
  class Error < Exception
  end

  class AuthorizationFailedException < Error
    def initialize
      super "Invalid authorization credentials : HTTP 403"
    end
  end

  class PageNotFoundException < Error
    def initialize
      super "Request was rate limited : HTTP 429"
    end
  end

  class RateLimitedException < Error
    def initialize
      super "Request was rate limited : HTTP 429"
    end
  end

  class Location
    include JSON::Serializable

    getter ip : String
    getter network : String
    getter version : String
    getter city : String
    getter region : String
    getter region_code : String
    getter country : String
    getter country_name : String
    getter country_code : String
    getter country_code_iso3 : String
    getter country_capital : String
    getter country_tld : String
    getter continent_code : String
    getter in_eu : Bool
    getter postal : String
    getter latitude : Float64
    getter longitude : Float64
    getter timezone : String
    getter utc_offset : String
    getter country_calling_code : String
    getter currency : String
    getter currency_name : String
    getter languages : String
    getter country_area : Float64
    getter country_population : Int32
    getter asn : String
    getter org : String
  end

  class ErrorResponse
    include JSON::Serializable

    getter ip : String
    getter error : Bool
    getter reason : String
  end
end
