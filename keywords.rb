class Keywords
  include Enumerable

  def initialize keywords
    @keywords = keywords
  end

  def each &block
    @keywords.each(&block)
  end

  def to_s
    @keywords.sort.map(&:to_s).join "\n"
  end
end

class Keyword
  include Comparable

  attr_reader :pattern, :name, :nb_found

  def <=> other
    nb_found <=> other.nb_found
  end

  def initialize name, pattern = nil
    @name = name
    @pattern = pattern || /\b#{Regexp.escape(name)}\b/i
    @nb_found = 0
  end

  def find_in text
    self.nb_found += 1 if present_in? text
  end

  def to_s
    "#{name}: #{nb_found}"
  end

  private

  attr_writer :nb_found

  def present_in? text
    !text.scan(pattern).empty?
  end
end
