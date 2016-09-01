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

  def save_directory
    File.expand_path("../#{Date.today}", __FILE__)
  end

  def save_offer offer, index
    filepath = File.join(save_directory, (index + 1).to_s)
    File.open(filepath, 'w') { |file| file.write offer.serialize }
  end

  def save_offers
    Dir.mkdir save_directory unless File.exist? save_directory
    offers.each_with_index { |offer, index| save_offer offer, index }
    puts "\n#{nb_offers} offers have been successfully saved inside"\
      " #{save_directory}."
  end

  def nb_offers
    offers.size
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
