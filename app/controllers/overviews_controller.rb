class OverviewsController < ApplicationController
  before_action :set_overview, only: [:show, :edit, :update, :destroy]

  # GET /overviews
  # GET /overviews.json
  def index
    @overviews = Overview.all
  end

  # GET /overviews/1
  # GET /overviews/1.json
  def show
  end

  # GET /overviews/new
  def new
    @overview = Overview.new
  end

  # GET /overviews/1/edit
  def edit
  end

  # POST /overviews
  # POST /overviews.json
  def create
    @overview = Overview.new(overview_params)

    respond_to do |format|
      if @overview.save
        format.html { redirect_to @overview, notice: 'Overview was successfully created.' }
        format.json { render action: 'show', status: :created, location: @overview }
      else
        format.html { render action: 'new' }
        format.json { render json: @overview.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /overviews/1
  # PATCH/PUT /overviews/1.json
  def update
    respond_to do |format|
      if @overview.update(overview_params)
        format.html { redirect_to @overview, notice: 'Overview was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @overview.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /overviews/1
  # DELETE /overviews/1.json
  def destroy
    @overview.destroy
    respond_to do |format|
      format.html { redirect_to overviews_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_overview
      @overview = Overview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def overview_params
      params[:overview]
    end
end
