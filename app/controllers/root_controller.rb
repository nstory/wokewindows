class RootController < ApplicationController
  def index
  end

  def up
    render plain: "up"
  end
end
