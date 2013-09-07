class UserController < ApplicationController

  def update
    params[:tags].each do |name|
      tag = Tag.find_or_create_by(name: name.downcase.strip)
      @user.tags << tag
    end
  end

end
