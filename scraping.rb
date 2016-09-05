#! /usr/bin/env ruby

require 'mechanize'
require 'sqlite3'
require_relative 'multitrabajos_pages'

URL = 'http://www.multitrabajos.com/empleos-area-tecnologia-sistemas-y-'\
  'telecomunicaciones.html'.freeze

db = SQLite3::Database.new 'offers.db'

MultitrabajosPages.new(URL).save_offers db
