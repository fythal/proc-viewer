class BrokenObjectsController < ApplicationController
  def index
    @broken_anns = Ann.broken
  end
end
