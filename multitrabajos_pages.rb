require 'date'

class MultitrabajosPages
  include Enumerable
  attr_reader :offers

  def initialize url
    @current_page = MultitrabajosPage.new(Mechanize.new.get(url))
    @offers = reduce([]) { |a, e| a.concat e.offers }
  end

  def each
    while @current_page
      yield @current_page
      @current_page = @current_page.next
    end
  end

  def save_offers db
    offers.each do |offer|
      db.execute "INSERT INTO offers values (?, 'multitrabajos', date('now'));",
        offer.serialize
    end
    puts "\n#{offers.size} offers have been successfully saved."
  end
end

class MultitrabajosPage
  class << self
    attr_accessor :index
  end

  @index = 0

  def initialize page
    @page = page
    @index = self.class.index += 1
  end

  def offer_links
    page.links_with(css: 'a.aviso_box')
  end

  def offers
    offer_links.map do |offer_link|
      print '.'
      offer_link.click.search('#contenido_aviso').first
    end
  end

  def next
    next_page = page.link_with(text: 'Siguiente')&.click
    next_page ? self.class.new(next_page) : nil
  end

  def to_s
    "Page ##{index}"
  end

  private

  attr_reader :page, :index
end
