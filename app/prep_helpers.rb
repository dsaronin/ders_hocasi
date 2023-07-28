#!/usr/bin/env ruby
# DersHocası: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#
# hocasi prep helpers for views
# ------------------------------------------------------

module Sinatra

  module AssetHelpers
# ------------------------------------------------------
# ------------------------------------------------------
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
  #  prep_flashcards  -- DRY prep & start flashcards
  #  returns flashcard obj
  #  ------------------------------------------------------------
  def prep_flashcards(restore_session, new_settings)
    settings = (
      !restore_session || session[:settings].nil? ? 
      new_settings  :  
      YAML.load(session[:settings]) 
    )

    topic = ( settings && settings[:topic]  ?  settings[:topic]  : "def" )

      # ok even if settings==nil at this point
    return HOCASI.do_flashcards( [topic.to_s], settings )
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

      # ok even if settings==nil at this point
    player = prep_flashcards(restore_session, new_settings).start_card_player

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
        flash[:error] = "Invalid Topic or Source"
        redirect '/source'
    else  # quit command received
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
        flash[:error] = "Invalid Topic or Source"
        redirect '/source'
    else  # quit command received
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
  def helper_player_or_list(submit, settings)
    case submit
      when  /flashcards/ then helper_start_player( settings )
      when  /lists/      then helper_prep_lists( false, settings )
      else
        flash[:error] = "Unknown submit type"
        redirect '/'
      end  # case
  end

  # ------------------------------------------------------
  # topic, source, list
  # ------------------------------------------------------
  def helper_prep_lists(restore_session = true, new_settings=nil)

    card = prep_flashcards(restore_session, new_settings)

    if card.nil?    # due to exception
      flash[:error] = "Invalid Topic or Source"
      redirect '/'
    elsif !card.listable? 
      flash[:error] = "Cannot list Lessons nor Dictionary!"
      redirect '/settings'
    else
        # setup variables for player display
      @action_box = :action_player   # use special action box
      @skip_menu = true    # skips player menu
      @topic  = card.my_settings[:topic]
      @source = card.my_settings[:source]
      @list   = card.my_source.fc_data[0..50]
      @text   = card.text_or_bullets
      @recording_file = card.my_source.recording
      @time   = 0

      if @source == "Opposites"
        @subchar = [/::/, " &harr; "]
      end

         # save state in user's session
      session[:settings] = YAML.dump(  
        card.prep_serialize_settings  # capture state
      )

      haml :lists
    end  # outer if

  end

  # ------------------------------------------------------
  # 
  # ------------------------------------------------------
  def helper_prep_lessons( default=false )

    helper_get_settings

    if default
      @settings[:topic] = Lessons.default_topic 
      @settings[:cur_ptr] = 0
    end

    @settings[:source] = "Lessons"    # spoof the source
    card = prep_flashcards( false, @settings )

    if card.nil?    # due to exception
      flash[:error] = "Invalid Topic or Source"
      redirect '/'
    else
        # setup variables for player display
      @action_box = :action_player   # use special action box
      @skip_menu = true    # skips player menu

      @l   = card.my_source     # @l is the "lesson"
      @cur_ptr = card.my_settings[:cur_ptr]

      if @l.nil? || @cur_ptr.nil?  || @l.my_topic != @settings[:topic]
        flash[:error] = "Missing Topic for Lessons; choose another."
        redirect '/'
      else
        @recording_file = @l.recording
        @time   = 0

        @cur_ptr = 0 if @cur_ptr >= @l.fc_data.length

           # save state in user's session
        session[:settings] = YAML.dump(  
          card.prep_serialize_settings  # capture state
        )

        haml :lessons
      end
    end  # outer if

  end

# ------------------------------------------------------
  # *************************************************
# ------------------------------------------------------
        
  end   #  module AssetHelpers
        
# ------------------------------------------------------
  # *************************************************
# ------------------------------------------------------
      
  helpers AssetHelpers

# ------------------------------------------------------
  # *************************************************
# ------------------------------------------------------
end  # module sinatra 
