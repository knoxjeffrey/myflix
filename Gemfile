source 'https://rubygems.org'
ruby '2.1.5'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem "figaro"
gem 'sidekiq'
gem 'sinatra', :require => nil
gem 'puma'
gem 'paratrooper'


group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'faker', '~> 1.4.3'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem "capybara-webkit"
  gem 'launchy', '~> 2.4.3'
  gem 'capybara-email'
end

group :production do
  gem 'rails_12factor'
  gem "sentry-raven"
end
