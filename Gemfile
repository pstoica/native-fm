source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'pg'
gem 'simple_form', '>= 3.0.0.rc'
gem 'slim'
gem 'unicorn'
gem 'figaro'

gem 'websocket-rails'
gem 'bootstrap-sass', git: 'git://github.com/thomas-mcdonald/bootstrap-sass.git', branch: '3'

group :development do
  gem 'unicorn-rails'
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'haml-rails'
  gem 'haml2slim'
  gem 'html2haml'
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
end