class TagsController < ApplicationController
  respond_to :json
  
  def index
    @tags = current_user.tags

    respond_with(@tags)
  end

  def create
    @tag = Tag.find_or_create_by(name: tag_params[:name].downcase.strip)

    current_user.tags << @tag
    current_user.save

    respond_with @tag
  end

  def destroy
    @tag = current_user.tags.find(params[:id])

    @tag.destroy

    respond_with @tag
  end

  def show
    @tag = current_user.tags.find(params[:id])
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end
