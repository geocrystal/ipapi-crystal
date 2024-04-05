require "http/client"
require "json"

# Crystal bindings for https://ipapi.co (IP Address Location & Geolocation API)
#
# API Docs : https://ipapi.co/api/
module Ipapi
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  FIELDS = [
    "ip",
    "city",
    "region",
    "region_code",
    "country",
    "country_name",
    "continent_code",
    "in_eu",
    "postal",
    "latitude",
    "longitude",
    "latlong",
    "timezone",
    "utc_offset",
    "languages",
    "country_calling_code",
    "currency",
    "asn",
    "org",
  ]

  class Client
    API_URL = "https://ipapi.co/"

    def initialize(@api_key : String? = nil)
    end

    # Location of a specific IP
    def locate(ip_address : String) : Location?
      url = "#{API_URL}#{ip_address}/json"
      url = url + "?key=#{@api_key}" if @api_key

      response = HTTP::Client.get(url)

      parse_locate_response(response)
    end

    # Location of client’s IP
    def locate : Location?
      url = "#{API_URL}json"
      url = url + "?key=#{@api_key}" if @api_key

      response = HTTP::Client.get(url)

      parse_locate_response(response)
    end

    {% for field in FIELDS %}
      def {{field.id}}(ip_address : String) : String
        url = "#{API_URL}#{ip_address}/{{field.id}}"
        url = url + "?key=#{@api_key}" if @api_key

        response = HTTP::Client.get(url)
        response.body
      end

      def {{field.id}} : String
        url = "#{API_URL}{{field.id}}"
        url = url + "?key=#{@api_key}" if @api_key

        response = HTTP::Client.get(url)
        response.body
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

    property ip : String
    property network : String
    property version : String
    property city : String
    property region : String
    property region_code : String
    property country : String
    property country_name : String
    property country_code : String
    property country_code_iso3 : String
    property country_capital : String
    property country_tld : String
    property continent_code : String
    property in_eu : Bool
    property postal : String
    property latitude : Float64
    property longitude : Float64
    property timezone : String
    property utc_offset : String
    property country_calling_code : String
    property currency : String
    property currency_name : String
    property languages : String
    property country_area : Float64
    property country_population : Int32
    property asn : String
    property org : String
  end

  class ErrorResponse
    include JSON::Serializable

    property ip : String
    property error : Bool
    property reason : String
  end
end
