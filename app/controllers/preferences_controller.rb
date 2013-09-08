class PreferencesController < ApplicationController
  respond_to :json
  
  def index
    @preferences = current_user.preferences

    respond_with(@preferences)
  end

  def create
    @tag = Tag.find_or_create_by(name: tag_params[:name].downcase.strip)
    @preference = current_user.preferences.new(tag: @tag)
    
    @preference.save

    respond_with @preference
  end

  def destroy
    @preference = current_user.preferences.find(params[:id])

    @preference.destroy

    respond_with @preference
  end

  def show
    @preference = current_user.preferences.find(params[:id])
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end
