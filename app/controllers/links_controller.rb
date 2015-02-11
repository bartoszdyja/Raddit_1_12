class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :upvote]

  # GET /links
  # GET /links.json
  def index
    
    if params[:sort]
      @p=params[:sort]
      @t=params[:type]
      @links = Link.order("#{@t} #{@p}").all
    else
      @links = Link.order("created_at DESC").all
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    @comments = @link.comments.order("created_at DESC").all
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)
    @user = current_user
    @link.user_id = @user.id

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @link =Link.find(params[:id])
    @user = current_user
    if user_signed_in?
      @link.liked_by @user
      flash.now[:notice] = 'You liked this.'
      render :show
    else
      redirect_to new_user_session_path, notice: 'You need to be logged in to vote.'
    end 
  end

  def downvote
    @link =Link.find(params[:id])
    @user = current_user
    @link.disliked_by @user
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:title, :url)
    end
end
