class Api::V1::VideosController < ApplicationController
  before_action :set_videos, only: [:index]
  before_action :set_video, only: [:show]

  def index
  end

  def show
  end

  def create
    @video = Video.create! video_params
  end

  private

  def video_params
    params.permit(:name, :file)
  end

  def set_videos
    @videos = Video.all
  end

  def set_video
    @video = Video.find(params[:id])
  end
end
