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

class HocasiApp < Sinatra::Application
  set :root, File.dirname(__FILE__)

  enable :sessions

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  get '/' do
    haml :index
  end

  get '/about' do
    haml :about
  end

  get '/start' do
    player = HOCASI.do_flashcards( ["def"] )
    (loop, show) = player.commands( [Player::PCMD_CURR]  )
    session[:settings] = player.card.serialize
    
    if loop
      @action_box = :action_player   # use special action box
      @dark_background = true

      @front = show[0]
      @rear = show[1]
      @topic = "topic"
      @sample = "sample sentence"

      @fontsize = case @front.length
                  when (1..7)   then "huge"
                  when (8..10)  then "large"
                  when (11..17) then "big1"
                  when (18..22) then "big2"
                  when (23..32) then "big3"
                  else 
                    "normal"
                  end

      haml :start_player
    else
      redirect '/'
    end
  end  # /start

  get '/next' do
    settings = session.delete(:settings)


    haml :start_player
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # HocasiApp 
