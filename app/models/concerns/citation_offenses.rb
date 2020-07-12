module CitationOffenses
  extend ActiveSupport::Concern

  class Coder
    def self.dump(obj)
      ActiveSupport::JSON.encode(obj.map(&:attributes))
    end

    def self.load(json)
      return [] if json.blank?
      JSON.parse(json).map { |j| CitationOffense.new(j) }
    end
  end

  included do
    serialize :offenses, Coder
  end

  def add_offense(offense)
    offenses << offense if !offenses.include?(offense)
  end
end
