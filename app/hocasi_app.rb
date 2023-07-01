#!/usr/bin/env ruby
# DersHocası: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#
# cekimi_app.rb  -- starting point for sinatra web app
#

  require 'sinatra'
  require 'pp'   # pretty print
  require_relative 'tag_helpers'
  require 'sinatra/form_helpers'
  require 'yaml'

class HocasiApp < Sinatra::Application
  set :root, File.dirname(__FILE__)

  enable :sessions


  #  ------------------------------------------------------------
  #  helper_prep_player  -- does common player setup preparations
  #  args: restore_session=true if restore session; default false
  #  returns: true if keep playing card; false to exit player
  #  ------------------------------------------------------------
  def helper_prep_player( restore_session = false )

    if restore_session
      settings = YAML.load( session.delete(:settings) )
    end

      # ok if settings.nil? at this point
    player = HOCASI.do_flashcards( ["def"], settings )
    if player.nil?
      loop = false
    else
      (loop, show) = player.commands( [Player::PCMD_CURR]  )

      session[:settings] = YAML.dump(  
        player.card.prep_serialize_settings
      )

      if loop
        @action_box = :action_player   # use special action box
        @dark_background = true

        @front = show[0]
        @rear  = show[1]

          # temp values for debugging/development
        @topic = "topic"
        @sample = "sample sentence"

          # calculate variable font sizing
        @fontsize = case @front.length
                    when (1..7)   then "huge"
                    when (8..10)  then "large"
                    when (11..17) then "big1"
                    when (18..22) then "big2"
                    when (23..32) then "big3"
                    else 
                      "normal"
                    end

      end  # inner if
    end  # outer if

    return loop
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  get '/' do
    haml :index
  end

  get '/about' do
    haml :about
  end

  get '/start' do

    if helper_player_prep
      haml :start_player
    else  # quit command received
      redirect '/'
    end

  end  # /start

  get '/next' do


    haml :start_player
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # HocasiApp 
