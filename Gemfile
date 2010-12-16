source 'http://rubygems.org'

gem 'rails', '3.0.3'
gem 'mysql2'
gem 'inherited_resources'
gem 'haml'
gem "json"

group :production do
  gem "memcache-client"
  gem 'memcached-northscale', :require => 'memcached'
  gem 'hassle', :git => "http://github.com/Papipo/hassle.git"
end

group :development, :test do
  gem 'rspec-rails'
end
