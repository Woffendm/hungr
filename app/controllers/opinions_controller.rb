class OpinionsController < ApplicationController
  before_action :set_opinion, only: [:show, :edit, :update, :destroy]

  # GET /opinions
  # GET /opinions.json
  def index
    if @current_user.opinions.blank?
      Opinion.create(:restaurant_id => Restaurant.first.id, :user_id => @current_user.id)
    end
    Restaurant.where("id NOT IN (?)", Opinion.where(:user_id => @current_user.id).pluck(:restaurant_id)).each do |restaurant|
      Opinion.create(:user_id => @current_user.id, :restaurant_id => restaurant.id)
    end
    @opinions = Opinion.where(:user_id => @current_user.id).includes(:restaurant)
  end
  
  def update_opinions
    params[:opinions].each do |id, values|
      next if values['like'].blank?
      Opinion.find(id).update(:like => values['like'])
    end
    redirect_to opinions_path
  end

  # GET /opinions/1
  # GET /opinions/1.json
  def show
  end

  # GET /opinions/new
  def new
    @opinion = Opinion.new
  end

  # GET /opinions/1/edit
  def edit
  end

  # POST /opinions
  # POST /opinions.json
  def create
    @opinion = Opinion.new(opinion_params)

    respond_to do |format|
      if @opinion.save
        format.html { redirect_to @opinion, notice: 'Opinion was successfully created.' }
        format.json { render action: 'show', status: :created, location: @opinion }
      else
        format.html { render action: 'new' }
        format.json { render json: @opinion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opinions/1
  # PATCH/PUT /opinions/1.json
  def update
    respond_to do |format|
      if @opinion.update(opinion_params)
        format.html { redirect_to @opinion, notice: 'Opinion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @opinion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opinions/1
  # DELETE /opinions/1.json
  def destroy
    @opinion.destroy
    respond_to do |format|
      format.html { redirect_to opinions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opinion
      @opinion = Opinion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opinion_params
      params.require(:opinion).permit(:user_id, :restaurant_id, :like)
    end
end
