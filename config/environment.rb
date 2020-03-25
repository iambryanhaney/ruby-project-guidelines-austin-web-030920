require 'bundler'
Bundler.require
require_all 'app/models'
require 'open-uri'
require 'net/http'
require 'json'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
