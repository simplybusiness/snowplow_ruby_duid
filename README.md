# Snowplow Ruby Domain UserId

A gem that exposes the Snowplow domain userid in Rack applications. Also allows you to set your own domain userid that will be shared with the Snowplow Javascript tracker. Related Snowplow Google Group discussion [here](https://groups.google.com/forum/#!topic/snowplow-user/GFfhW25UuN8).

## Instructions

Add the gem to your Gemfile

```ruby
gem 'snowplow_ruby_duid'
```

### Rails

The helper will be included in `ActionController::Base` when the gem is loaded.

#### Configuration

Since 2020 some browsers require extra settings on cookies, like [SameSite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite) and [secure](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#Secure) settings.

The library provides default values for these two settings(:lax, false), that you can change: 

```ruby
SnowplowRubyDuid::Configuration.same_site = :none
SnowplowRubyDuid::Configuration.secure = true
```

### Sinatra

Add the following to `Sinatra::Base`

```ruby
require 'snowplow_ruby_duid'
helpers SnowplowRubyDuid::Helper
```

### Usage

A method called `snowplow_domain_userid` will be exposed in your application's context. Calling this method results in the following behaviour:

- If there is already a Snowplow domain userid in the request's cookie, the value of the id will be returned.
- Else, a Snowplow domain userid will be generated and persisted in the response's cookie. This domain userid will continue to be used by the Snowplow Javascript tracker on the client side.

## Running the specs and features

Use this command to run the specs and features: `bundle exec rspec`
