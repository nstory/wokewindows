module BagOfText
  extend ActiveSupport::Concern

  included do
    before_save :update_bag_of_text
  end

  def bag_of_text_content
    raise "bag_of_text_content must be implemented!"
  end

  def update_bag_of_text
    self.bag_of_text = bag_of_text_content.flatten
      .join(" ").split(/\s+/).uniq.join(" ")
  end
end
