class BrokenObjectsController < ApplicationController

  skip_before_action :identify_user

  def index
    @broken_anns = Ann.broken
  end
end
