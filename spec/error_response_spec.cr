require "./spec_helper"

class ErrorResponseTestClient < Ipapi::Client
  def parse_response(response, field : Bool)
    if field
      parse_field_response(response)
    else
      parse_locate_response(response)
    end
  end
end

describe "API error responses" do
  client = ErrorResponseTestClient.new

  [false, true].each do |field|
    context "#{field ? "field" : "location"} response" do
      it "preserves the exception type and uses the API description" do
        response = HTTP::Client::Response.new(429, body: %({"error":true,"reason":"RateLimited","message":"Daily quota exceeded"}))

        expect_raises(Ipapi::RateLimitedException, "Daily quota exceeded") do
          client.parse_response(response, field)
        end
      end

      it "uses the reason when the description is missing" do
        response = HTTP::Client::Response.new(429, body: %({"error":true,"reason":"RateLimited"}))

        expect_raises(Ipapi::RateLimitedException, "RateLimited") do
          client.parse_response(response, field)
        end
      end

      ["", "<html>Unavailable</html>", "{", "[]", %({"message":null}), %({"message":123})].each do |body|
        it "keeps the default message for #{body.inspect}" do
          response = HTTP::Client::Response.new(429, body: body)

          expect_raises(Ipapi::RateLimitedException, "Request was rate limited : HTTP 429") do
            client.parse_response(response, field)
          end
        end
      end

      it "preserves authentication and not-found exception types" do
        response = HTTP::Client::Response.new(403, body: %({"message":"Invalid API key"}))
        expect_raises(Ipapi::AuthorizationFailedException, "Invalid API key") do
          client.parse_response(response, field)
        end

        response = HTTP::Client::Response.new(404, body: "")
        expect_raises(Ipapi::PageNotFoundException, "Page not found : HTTP 404") do
          client.parse_response(response, field)
        end
      end

      it "uses descriptions for other HTTP errors" do
        response = HTTP::Client::Response.new(400, body: %({"message":"Bad request"}))
        expect_raises(Ipapi::Error, "Bad request") do
          client.parse_response(response, field)
        end
      end

      it "preserves unstructured bodies for other HTTP errors" do
        response = HTTP::Client::Response.new(500, body: "Unavailable")
        expect_raises(Ipapi::Error, "Unavailable") do
          client.parse_response(response, field)
        end
      end
    end
  end

  it "uses the description for errors returned with HTTP 200" do
    response = HTTP::Client::Response.new(200, body: %({"ip":"invalid","error":true,"reason":"Invalid IP Address","message":"Check the IP address"}))
    expect_raises(Ipapi::Error, "Check the IP address") do
      client.parse_response(response, false)
    end
  end

  it "preserves the reason for HTTP 200 errors without a description" do
    response = HTTP::Client::Response.new(200, body: %({"ip":"invalid","error":true,"reason":"Invalid IP Address"}))
    expect_raises(Ipapi::Error, "Invalid IP Address") do
      client.parse_response(response, false)
    end
  end
end
