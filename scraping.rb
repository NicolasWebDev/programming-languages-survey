#! /usr/bin/env ruby

require 'mechanize'
require 'sqlite3'
require_relative 'multitrabajos_pages'

MULTITRABAJO_URL = 'http://www.multitrabajos.com/'\
  'empleos-area-tecnologia-sistemas-y-telecomunicaciones.html'.freeze
COMPUTRABAJO_URL = 'http://www.computrabajo.com.ec/'\
  'empleos-de-informatica-y-telecom'.freeze

db = SQLite3::Database.new 'offers.db'

Pages.new('multitrabajos', MultitrabajosPage, MULTITRABAJO_URL).save_offers db
Pages.new('computrabajo', ComputrabajoPage, COMPUTRABAJO_URL).save_offers db
