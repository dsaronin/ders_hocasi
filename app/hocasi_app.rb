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
    
    if loop
      @action_box = :action_player   # use special action box

      @front = show[0]
      @rear = show[1]
      @topic = "topic"
      @sample = "sample sentence"

      haml :start_player
    else
      redirect '/'
    end
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # HocasiApp 
