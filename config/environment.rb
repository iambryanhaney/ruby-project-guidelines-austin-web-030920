require 'bundler'
Bundler.require
require_all 'app/models'

require 'open-uri'
require 'net/http'
require 'json'

require 'io/console'
require 'awesome_print'

require 'down'
require 'catpix'

require_relative '../bin/menu.rb'
require_relative '../bin/seatgeek.rb'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

ActiveRecord::Base.logger = nil
