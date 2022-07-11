# frozen_string_literal: true

class ApplicationController < ActionController::Base
  require './services/flickr_service.rb'

  def index
    if params[:userid].present?

      hash = FlickrService.new
      @pictures = hash.get_pictures(params[:userid])

    elsif !params[:userid].nil? && params[:userid].empty?

      flash[:warning] = 'Please Enter a User ID'
      redirect_to root_path
    end

    if @pictures.class == String
      flash[:alert] = 'User not found'
      render :index, status: :unprocessable_entity
    elsif !@pictures.nil? && @pictures.class != String
      respond_to do |format|
        format.json
        format.html
      end

    end
  end
end
