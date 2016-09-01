#! /usr/bin/env ruby

require_relative 'keywords'

def build_keywords
  keywords = %w(python sap java mysql sql php ruby html sql-server c# asp.net
                javascsript xml html5 css scrum laravel symfony rails node linux
                css3 svn git android ios angular angularjs react reactjs ajax
                linq mvc ember emberjs erp jquery haskell clojure windows mac
                web c++ perl lisp bash c go r go swift scala lua clojure matlab
                rust unix eclipse
                visual\ studio).map { |keyword| Keyword.new keyword }
  keywords << Keyword.new('.net', /\W\.net\b/i)
end

keywords = Keywords.new build_keywords

def search_keywords filename, keywords
  offer = File.read filename
  keywords.each { |keyword| keyword.find_in offer }
end

Dir.glob("#{File.dirname(__FILE__)}/2016*/[0-9]*") { |filename| search_keywords filename, keywords }
puts keywords
