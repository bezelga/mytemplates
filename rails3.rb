# rails new my_app_name -J -T -m http://gist.github.com/635287.txt

remove_file 'Gemfile'
create_file 'Gemfile', <<-GEMFILE
source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'mysql2'
gem 'mongrel'
gem 'haml-rails'

# Generators
gem 'rails3-generators' # generators for non-rails-3-compatible apps 
gem 'nifty-generators'  # generators for non-rails-3-compatible apps 

# View Helpers
gem 'jquery-rails'

# Test
group :test, :cucumber, :development do
  gem 'factory_girl' # replaces fixtures
  gem 'factory_girl_rails', '~> 1.0.0' # for rails 3
  gem 'autotest'
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
end

# Development tools
group :development do
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
#get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
get "https://github.com/rails/jquery-ujs/blob/master/src/rails.js", "public/javascripts/rails.js"
gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

# Remove crap
remove_file "public/index.html"
remove_file "app/views/layouts/application.html.erb"
remove_file "public/robots.txt"

# Database and RSpec/Cucumber
rake "db:migrate"
generate "rspec:install"
generate "cucumber:install --rspec --capybara"
generate "pickle"
