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

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # HocasiApp 
