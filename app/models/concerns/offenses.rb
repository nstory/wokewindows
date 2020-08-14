module Offenses
  extend ActiveSupport::Concern

  class Coder
    def initialize(offense_class)
      @offense_class = offense_class
    end

    def dump(obj)
      ActiveSupport::JSON.encode(obj.map(&:attributes))
    end

    def load(json)
      return [] if json.blank?
      JSON.parse(json).map { |j| @offense_class.new(j) }
    end
  end

  included do
    serialize :offenses, Coder.new(Offense)
    serialize :nibrs_offenses, Coder.new(NibrsOffense)
  end

  def add_offense(offense)
    offenses << offense if !offenses.include?(offense)
  end

  def add_nibrs_offense(nibrs_offense)
    nibrs_offenses << nibrs_offense if !nibrs_offenses.include?(nibrs_offense)
  end
end
