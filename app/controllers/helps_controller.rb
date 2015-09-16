class HelpsController < ApplicationController

  before_action :authenticate_user!

  def show
    render layout: false
  end

end
