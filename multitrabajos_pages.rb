require 'date'

class Page
  class << self
    attr_accessor :offer_link_selector, :offer_content_selector, :next_page_text
  end

  def initialize page
    @page = page
  end

  def offer_links
    page.links_with(css: self.class.offer_link_selector)
  end

  def offers
    offer_links.map do |offer_link|
      print '.'
      offer_link.click.search(self.class.offer_content_selector).first
    end
  end

  def next
    next_page = page.link_with(text: self.class.next_page_text)&.click
    next_page ? self.class.new(next_page) : nil
  end

  protected

  attr_reader :page
end

class MultitrabajosPage < Page
  @offer_link_selector = 'a.aviso_box'.freeze
  @offer_content_selector = '#contenido_aviso'.freeze
  @next_page_text = 'Siguiente'.freeze
end

class ComputrabajoPage < Page
  @offer_link_selector = 'a.js-o-link'.freeze
  @offer_content_selector = '.detalle_oferta'.freeze
  @next_page_text = 'Siguiente'.freeze
end

class Pages
  include Enumerable
  attr_reader :offers, :name

  def initialize name, page_class, url
    @current_page = page_class.new(Mechanize.new.get(url))
    @offers = reduce([]) { |a, e| a.concat e.offers }
    @name = name
  end

  def each
    while @current_page
      yield @current_page
      @current_page = @current_page.next
    end
  end

  def save_offers db
    offers.each do |offer|
      db.execute "INSERT INTO offers values (?, ?, date('now'));",
        [offer.serialize, name]
    end
    puts "\n#{offers.size} offers have been successfully saved."
  end
end
