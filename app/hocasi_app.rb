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
  #  ------------------------------------------------------------
  def prep_dialog
    @front = @front.gsub( /^.: / , "" )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def prep_opposites
    @front = @front.gsub( /::/, " &harr; " )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def prep_dictionary
    @rear = @rear.split( /; / )
  end

  #  ------------------------------------------------------------
  #  helper_ready_haml_stuff  -- stuff to get ready for view
  #  ------------------------------------------------------------
  def helper_ready_haml_stuff( card, show )
    @action_box = :action_player   # use special action box
    @dark_background = true

    @front = show[0]
    @rear  = show[1]
    @time  = show[2] || 0    # maybe will be a time code for audio

    key = case card.my_settings[:side]
           when /front/ then card.extract_key( @front )
           when /back/  then card.extract_key( @rear )
           else
             ""   # empty key
           end
    @examples = card.mine_examples( key )
    @settings = card.my_settings
    @source = card.my_settings[:source]
    @recording_file = card.my_source.recording

    case @source
      when /Dialogs/    then prep_dialog
      when /Opposites/  then prep_opposites
      when /Dictionary/  then prep_dictionary
    end

    helper_font_sizing
  end

  #  ------------------------------------------------------------
  #  helper_font_sizing  -- calcs size of font for player display
  #  ------------------------------------------------------------
  def helper_font_sizing
      # calculate variable font sizing
    @fontsize = case @front.length
                when (1..5)   then "huge"
                when (6..8)   then "large"
                when (9..16)  then "big1"
                when (17..39) then "big2"
                when (40..59) then "big3"
                else 
                  "normal"
                end
  end

  #  ------------------------------------------------------------
  #  helper_prep_player  -- does common player setup preparations
  #  args: 
  #    playcmd: command to be passed to player
  #    restore_session:  true if restore session; default false
  #    settings: nil or new set of settings for starting player
  #  returns: true if keep playing card; false to exit player
  #  ------------------------------------------------------------
  def helper_prep_player(playcmd = Player::PCMD_CURR, restore_session = false, new_settings=nil)

    @redirect_to_source = false

    if restore_session
      settings = YAML.load( session[:settings] ) unless session[:settings].nil?
    else
      settings = new_settings
    end

    topic = ( settings && settings[:topic]  ?  settings[:topic]  : "def" )

      # ok even if settings==nil at this point
    player = HOCASI.do_flashcards( [topic.to_s], settings )

    if player.nil?  # due to exception
      loop = false
      if ($!.nil? || $!.message.match( /^Source/ ) )
        @redirect_to_source = true  
      end
    else
        # have the player do a command
      (loop, show) = player.commands( [playcmd] )

        # save state in user's session
      session[:settings] = YAML.dump(  
        player.card.prep_serialize_settings  # capture state
      )

        # setup variables for player display
      if loop
        helper_ready_haml_stuff( player.card, show )
      end  # inner if

    end  # outer if

    return loop
  end

  #  ------------------------------------------------------------
  #  helper_do_player  -- DRYs up player controls coding
  #    primary difference from starting, is that we want to
  #    restore state from rack-sessions cookie
  #  ------------------------------------------------------------
  def helper_do_player( cmd )
    if helper_prep_player(cmd, true)
      haml :start_player
    elsif @redirect_to_source
        redirect '/source'
    else  # quit command received
        # TODO: could be here because of error; needs to be shown
      redirect '/'
    end
  end

  #  ------------------------------------------------------------
  #  helper_start_player  -- used to start player
  #    with default or changed settings
  #    primary difference from do_player, is that we do not want to
  #    restore state from rack-sessions cookie; we'll either
  #    use a new changed settings OR the current default settings
  #  ------------------------------------------------------------
  def helper_start_player(settings = nil)
    if helper_prep_player( Player::PCMD_CURR, false, settings )
      haml :start_player
    elsif @redirect_to_source
        redirect '/source'
    else  # quit command received
        # TODO: could be here because of error; needs to be shown
      redirect '/'
    end
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def helper_get_settings()
    @settings = ( session[:settings].nil?  ?
      FlashManager.default_settings :
      YAML.load( session[:settings] ) 
    )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  get '/' do
    haml :index
  end

  get '/source' do
    helper_get_settings
    @key_list = Module.const_get( @settings[:source] ).sorted_keys
    @settings[:entry] ||= @key_list.first
    @entry_def = @settings[:entry].to_sym
    haml :source
  end

  get '/about' do
    haml :about
  end

  get '/settings' do
    helper_get_settings
    haml :settings
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  get '/start' do
    helper_start_player
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

  get '/gnext' do
    helper_do_player( Player::PCMD_NEXT_GRP )
  end

  get '/gprev' do
    helper_do_player( Player::PCMD_PREV_GRP )
  end

  get '/ghead' do
    helper_do_player( Player::PCMD_GHEAD )
  end

  get '/flip' do
    helper_do_player( Player::PCMD_FLIP )
  end

  get '/quit' do
    helper_do_player( Player::PCMD_QUIT )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  post '/settings' do
    # pp request.env
    parms = params[:settings]
    helper_start_player(
      {
        :topic    => parms[:topic],
        :source   => parms[:source],
        :selector => parms[:order],
        :sizer    => parms[:sizer].to_i,
        :side     => parms[:side]
      }
    )
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  post '/source' do
    parms = params[:source]
    helper_get_settings
    @settings[:entry] = parms[:entry]
    helper_start_player( @settings )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # HocasiApp 
