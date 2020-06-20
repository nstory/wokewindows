module Attributable
  extend ActiveSupport::Concern

  class Coder
    def self.dump(obj)
      ActiveSupport::JSON.encode(obj.map(&:attributes))
    end

    def self.load(json)
      if json.blank?
        []
      else
        JSON.parse(json).map { |j| Attribution.new(j) }
      end
    end
  end

  included do
    serialize :attributions, Coder
  end

  def add_attribution(attribution)
    attribution.validate!
    return if attributions.map(&:filename).include?(attribution.filename)
    attributions << attribution
  end
end
