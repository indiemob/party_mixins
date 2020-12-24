# frozen_string_literal: true

RSpec.describe PartyMixins do
  it "has a version number" do
    expect(PartyMixins::VERSION).not_to be nil
  end

  it "returns parsed_response when party_method is present and respose.ok?" do
    BASE_URI = "https://api.example.com"
    id = 123
    stub_request(:get, "#{BASE_URI}/posts/#{id}").to_return(mock_response)

    class ExampleClientWithPartyMethod
      include HTTParty
      include PartyMixins

      base_uri BASE_URI

      party_method
      def get_post(id)
        self.class.get("/posts/#{id}")
      end
    end

    client = ExampleClientWithPartyMethod.new
    expect(client.get_post(id)).to be_a(Hash)
  end

  it "returns the direct response when party_method is not present" do
    BASE_URI = "https://api.example.com"
    id = 123
    stub_request(:get, "#{BASE_URI}/posts/#{id}").to_return(mock_response)

    class ExampleClientNoPartyMethod
      include HTTParty
      include PartyMixins

      base_uri BASE_URI

      def get_post(id)
        self.class.get("/posts/#{id}")
      end
    end

    client = ExampleClientNoPartyMethod.new
    expect(client.get_post(id)).to be_a(HTTParty::Response)
  end

  it "raises ServiceError when response not ok" do
    BASE_URI = "https://api.example.com"
    id = 123
    stub_request(:get, "#{BASE_URI}/posts/#{id}").to_return(mock_response(400))

    class ExampleClientBadResponse
      include HTTParty
      include PartyMixins

      base_uri BASE_URI

      party_method
      def get_post(id)
        self.class.get("/posts/#{id}")
      end
    end

    client = ExampleClientBadResponse.new

    expect do
      client.get_post(id)
    end.to(
      raise_error(
        an_instance_of(ServiceError).and(having_attributes(code: 400))
      )
    )
  end

  def mock_response(status = 200)
    {
      status: status,
      headers: { content_type: "application/json" },
      body: {
        title: "Foo",
        content: "Bar"
      }.to_json
    }
  end
end
