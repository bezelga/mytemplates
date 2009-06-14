def commit(message)
	git :add => "."
	git :commit => "-m '#{message}'"
end

plugin 'sexy_scaffold',
	:git => "git://github.com/dfischer/sexy_scaffold.git"

plugin 'make_resourceful',
	:git => "git://github.com/hcatlin/make_resourceful.git"

run "haml --rails ."

plugin 'rspec',
  :git => 'git://github.com/dchelimsky/rspec.git'

plugin 'rspec-rails',
	  :git => 'git://github.com/dchelimsky/rspec-rails.git'

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

commit('Initial commit')

if yes?("Wanna use authentication?")
	plugin 'restful-authentication',
		:git => 'git://github.com/technoweenie/restful-authentication.git'
	generate('authenticated','user session')
	commit('Added authentication')
end


