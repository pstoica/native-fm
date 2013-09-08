class UserController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json

  def update
    tags = []
    params[:tags].each do |name|
      tag = Tag.find_or_create_by(name: name.downcase.strip)
      tags << tag
    end

    current_user.tags = tags
    current_user.save

    respond_with(current_user)
  end

  def show
    respond_with(current_user)
  end
end
