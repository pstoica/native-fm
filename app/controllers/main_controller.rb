class MainController < ApplicationController
  def splash
  end

  def index
    unless user_signed_in?
      render :splash
    end
  end
end