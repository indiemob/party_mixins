# PartyMixins

HTTParty Extensions

Usage

```ruby
class ExampleClient
  include HTTParty
  include PartyMixins

  base_uri "https://api.example.com"

  party_method
  def get_post(id)
    self.class.get("/posts/#{id}")
  end

  def unaffected_get_post(id)
    self.class.get("/posts/#{id}")
  end
end

client = ExampleClient.new

# If response.ok?
client.get_post(123)
# => { "title" => "Foo", "content" => "Bar" }

# If !response.ok?
client.get_post("not_an_id")
# => ServiceError is raised with the response code

client.unaffected_get_post(123)
# => HTTParty::Response
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'party_mixins'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install party_mixins

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/party_mixins. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/party_mixins/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PartyMixins project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/party_mixins/blob/master/CODE_OF_CONDUCT.md).
