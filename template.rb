def commit(message)
	git :add => "."
	git :commit => "-m '#{message}'"
end

plugin 'sexy_scaffold',
	:git => "git://github.com/bezelga/sexy_scaffold.git"

plugin 'resource_controller',
	:git => "git://github.com/giraffesoft/resource_controller.git"

run "haml --rails ."

plugin 'rspec',
  :git => 'git://github.com/dchelimsky/rspec.git'

plugin 'rspec-rails',
	  :git => 'git://github.com/dchelimsky/rspec-rails.git'

plugin 'jrails',
        :git => 'git://github.com/aaronchi/jrails.git'

generate :rspec

gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'

rake "gems:install"

git :init

file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

commit('Initial commit with plugins from template')

if yes?("Wanna use authentication?")
	plugin 'restful-authentication',
		:git => 'git://github.com/technoweenie/restful-authentication.git'
	generate('authenticated','user session')
	commit('Added authentication')
end


