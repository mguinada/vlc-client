source 'https://rubygems.org'

gem 'rake', '~> 10.4.2'

group :development do
  gem 'guard-rspec', '~> 2.5.1'
  gem 'redcarpet'
  gem 'yard'
  gem 'pry'
end

group :test do
  platforms :ruby_19 do
    gem 'tins', '~> 1.6.0'
  end

  gem 'mime-types',  '< 2.0.0'
  gem 'rspec',       '~> 2.14.1', :require => false
  gem 'simplecov',   '~> 0.8.2',  :require => false
  gem 'coveralls',   '~> 0.7.0',  :require => false
  gem 'rest-client', '~> 1.6.7',  :require => false
end

gemspec
