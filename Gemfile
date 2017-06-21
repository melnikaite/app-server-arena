source 'https://rubygems.org'

gem 'sinatra'
gem 'json'
gem 'oauth'

gem 'rails'
gem 'arel'
gem 'sqlite3'

group :development, :test do
  gem 'pry'
end

group :production do
  gem 'ey_config'
  gem 'newrelic_rpm'
end

group :app_servers do
  gem 'puma'
  gem 'passenger'
  gem 'passenger-rails'
  gem 'rhebok'
  platforms :rbx do
    gem 'unicorn'
    gem 'unicorn-rails'
    gem 'thin'
  end
  platforms :ruby do
    gem 'iodine'
    gem 'unicorn'
    gem 'unicorn-rails'
    gem 'thin'
  end
end
