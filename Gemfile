source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'

gem 'dotenv'
gem 'whenever', :require => false
gem 'foreman'
gem 'sidekiq-cron'
gem 'httparty'
gem "active_model_serializers"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  #  gem 'rspec-rails'
end
