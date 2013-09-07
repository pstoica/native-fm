class MainController < ApplicationController
  def splash
  end

  def index
    unless user_signed_in?
      render :splash, layout: false
    end
  end
end