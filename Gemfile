source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails',                        '~> 5.1.3'
gem 'sqlite3',                      '1.3.13'
gem 'puma',                         '~> 3.0'
gem 'redis',                        '~> 3.0'
gem 'activerecord-import'
gem 'active_model_serializers'

# API Clients
gem 'gems',                         '1.0.0'
gem 'gitlab',                       '4.2.0'
gem 'nokogiri' # used to parse ruby-lang.com
# Assets
gem 'webpacker',                    '~> 2.0'
gem 'sass-rails',                   '5.0.6'
gem 'uglifier',                     '>= 1.3.0'
gem 'coffee-rails',                 '~> 4.2'
gem 'jquery-rails',                 '4.3.1'
gem 'bootstrap-sass',               '3.3.7'
gem 'font-awesome-sass',            '4.7.0'

group :development, :test do
  gem 'rspec-rails',                '3.6.0'
  gem 'guard',                      '2.14.1'
  gem 'guard-rspec',                '4.7.3'
  gem 'factory_girl',               '4.8.0'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers',           '3.1.1'
  gem 'byebug', platform: :mri
end

group :development do
  gem 'foreman',                    '0.64.0'
  gem 'web-console',                '>= 3.3.0'
  gem 'listen',                     '~> 3.0.5'
  gem 'annotate',                   '2.7.2'
  gem 'pry'
end

group :test do
  gem 'webmock',                    '3.0.1'
end
