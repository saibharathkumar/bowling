class FramesController < ApplicationController
  before_action :set_frame, only: [:show, :edit, :update, :destroy]

  # GET /frames
  # GET /frames.json
  def index
    @frames = Frame.all.where(:game_id => params[:game_id]).group_by(&:player_id)
    @game_id = params[:game_id]
    @game_turn = Game.find(@game_id).game_turn
  end

  # GET /frames/1
  # GET /frames/1.json
  def show
  end

  # GET /frames/new
  def new
    @frame = Frame.new
    @game_id = params[:game_id]
    @players = Player.where(:id => Game.find(@game_id).score_board.keys)
  end

  # GET /frames/1/edit
  def edit
  end

  # POST /frames
  # POST /frames.json
  # requires game id for frames for that game
  def create
    @game_id = params[:game_id]
    @players = Player.where(:id => Game.find(@game_id).score_board.keys)
    @frame = Frame.new(frame_params.merge!(game_id: @game_id))
    respond_to do |format|
      if @frame.save
        format.html { redirect_to game_frames_url, notice: 'Frame was successfully created.' }
        format.json { render :index, status: :created, location: @frame }
      else
        format.html { render :new }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frame
      @frame = Frame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def frame_params
      params.require(:frame).permit(:try1, :try2, :turn, :score, :player_id, :game_id)
    end
end
