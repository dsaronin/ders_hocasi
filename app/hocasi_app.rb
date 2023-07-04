#!/usr/bin/env ruby
# DersHocası: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#
# cekimi_app.rb  -- starting point for sinatra web app
#

  require 'sinatra'
  require 'pp'   # pretty print
  require_relative 'tag_helpers'
  require_relative 'player'
  require 'sinatra/form_helpers'
  require 'yaml'

class HocasiApp < Sinatra::Application

  enable :sessions

  set :root, File.dirname(__FILE__)

  #  ------------------------------------------------------------
  #  helper_prep_player  -- does common player setup preparations
  #  args: restore_session=true if restore session; default false
  #  returns: true if keep playing card; false to exit player
  #  ------------------------------------------------------------
  def helper_prep_player(playcmd = Player::PCMD_CURR, restore_session = false, topic ="def")

    if restore_session
      settings = YAML.load( session[:settings] ) unless session[:settings].nil?
    end

      # ok even if settings==nil at this point
    player = HOCASI.do_flashcards( [topic], settings )
    if player.nil?
      loop = false
    else
        # have the player do a command
      (loop, show) = player.commands( [playcmd] )

        # save state in user's session
      session[:settings] = YAML.dump(  
        player.card.prep_serialize_settings  # capture state
      )

        # setup variables for player display
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
                    when (1..5)   then "huge"
                    when (6..9)  then "large"
                    when (10..17) then "big1"
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
  #  helper_do_player  -- DRYs up all player access coding
  #  ------------------------------------------------------------
  def helper_do_player( cmd )
    if helper_prep_player(cmd, true)
      haml :start_player
    else  # quit command received
        # TODO: could be here because of error; needs to be shown
      redirect '/'
    end
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
    if helper_prep_player  # accept all defaults
      haml :start_player
    else  # quit command received
        # TODO: could be here because of error; needs to be shown
      redirect '/'
    end

  end  # /start

  get '/next' do
    helper_do_player( Player::PCMD_NEXT )
  end

  get '/prev' do
    helper_do_player( Player::PCMD_PREV )
  end

  get '/curr' do
    helper_do_player( Player::PCMD_CURR )
  end

  get '/shfl' do
    helper_do_player( Player::PCMD_SHUFFLE )
  end

  get '/unsh' do
    helper_do_player( Player::PCMD_UNSHFLE )
  end

  get '/reset' do
    helper_do_player( Player::PCMD_RESET )
  end

  get '/gplus' do
    helper_do_player( Player::PCMD_NEXT_GRP )
  end

  get '/gminus' do
    helper_do_player( Player::PCMD_PREV_GRP )
  end

  get '/ghead' do
    helper_do_player( Player::PCMD_GHEAD )
  end

  get '/quit' do
    helper_do_player( Player::PCMD_QUIT )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # HocasiApp 
