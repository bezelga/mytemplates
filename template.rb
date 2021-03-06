# rails new my_app_name -J -T -m http://gist.github.com/635287.txt

remove_file 'Gemfile'
create_file 'Gemfile', <<-GEMFILE
source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'pg', :group => :production

# Generators
gem 'rails3-generators' # generators for non-rails-3-compatible apps 
gem 'nifty-generators'  # generators for non-rails-3-compatible apps 

# View Helpers
gem 'jquery-rails'
gem 'json'


# Authentication & Authorization
gem 'devise'
gem 'cancan'

# Uploads
gem 'carrierwave' # simpler alternative to paperclip
gem 'mini_magick' # simpler interface to RMagick
gem 'paperclip'
gem 'aws' # amazon storage
  
# Search
gem 'thinking-sphinx', 
  :require => 'thinking_sphinx', 
  :git => "git://github.com/freelancing-god/thinking-sphinx.git", 
  :branch => "rails3"  

# Deploy
gem 'capistrano'

# Test
group :test, :cucumber, :development do
  gem 'factory_girl' # replaces fixtures
  gem 'factory_girl_rails', '~> 1.0.0' # for rails 3
end

group :test, :cucumber do
  gem 'capybara' # webrat replacement
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'pickle' # model helper for cucumber
  gem 'database_cleaner' # ensure clean state for testing
  gem 'rspec'
  gem 'rspec-rails'
  gem 'mocha' # library for mocking/stubbing
  gem 'webmock' # library for stubbing http requests
  gem 'spork'
  gem "jasmine",
    :git => "git://github.com/pivotal/jasmine-gem.git",
    :branch => "rspec2-rails3",
    :submodules => true
end

# Development tools
group :development do
  gem 'thin' # fast server
  gem 'wirble' # awesome irb
  gem 'awesome_print' # print ruby objects awesomely
end

GEMFILE

# Configuration
generators = <<-GENERATORS
    config.generators do |g|
      g.stylesheets false
      g.test_framework :rspec
      g.integration_tool    :cucumber
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.template_engine :haml
    end
GENERATORS
application generators

# SASS
# route "get '/stylesheets/:media.:ext' => SassCompiler" # this doesn't work
# get "http://gist.github.com/raw/326616/sass_compiler.rb", "lib/sass_compiler.rb"

# jQuery
get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

# Mailer
initializer 'mail.rb', <<-CODE
ActionMailer::Base.smtp_settings = {
 :address => "localhost",
 :port => 1025,
 :domain => "#{app_name}.com"
}
CODE

# Remove crap
remove_file "README"
remove_file "LICENSE"
remove_file "public/index.html"
remove_file "app/views/layouts/application.html.erb"
remove_file "public/favicon.ico"
remove_file "public/robots.txt"
remove_file "public/images/rails.png"

# Setup
run 'capify .'
run 'bundle install --without production'

# Database and RSpec/Cucumber
rake "db:migrate"
generate "rspec:install"
generate "cucumber:install --rspec --capybara"
generate "pickle"

# Git
gitignore = <<-CODE
.DS_Store
log/*.log
log/*.pid
config/database.yml
db/*.sqlite3
rerun.txt
public/system
db/sphinx
config/development.sphinx.conf
.bundle
tmp/**/*
**/.DS_Store
db/schema.rb
vendor/cache/*
CODE

create_file ".gitignore", gitignore
create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

git :init
git :add => "."
git :commit => "-m 'Initial commit'"
