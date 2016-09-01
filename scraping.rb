#! /usr/bin/env ruby

require 'mechanize'
require_relative 'multitrabajos_pages'

URL = 'http://www.multitrabajos.com/empleos-area-tecnologia-sistemas-y-'\
  'telecomunicaciones.html'.freeze

MultitrabajosPages.new(URL).save_offers
