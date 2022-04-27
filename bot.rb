require 'discordrb'

bot = Discordrb::Commands::CommandBot.new token: 'OTM1OTQ0MDYwMTM5NjI2NTk3.YfF_1A.4XnkJsvABTMTVDymDKrXTgYxqnY', prefix: '!' 

# done once, afterwards, you can remove this part if you want
puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(content: 'Ping!') do |event|
  # The `respond` method returns a `Message` object, which is stored in a variable `m`. The `edit` method is then called
  # to edit the message with the time difference between when the event was received and after the message was sent.
  m = event.respond('Pong!')
  m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

bot.message(content: 'Hi') do |event|
    event.respond 'Hi'
end 


#Mentionning the bot
bot.mention do |event|
    # The `pm` method is used to send a private message (also called a DM or direct message) to the user who sent the
    # initial message.
    event.user.pm('You have mentioned me!')
  end

#Personal Effort

bot.command(:help) do |event|
  event.user.pm('Help *INCOMING*'
  )
end

#SHutting down the bot
bot.command(:exit, help_available: false) do |event|
    # This is a check that only allows a user with a specific ID to execute this command. Otherwise, everyone would be
    # able to shut your bot down whenever they wanted.
    break unless event.user.id == 703997865982165442 # Replace number with your ID
  
    bot.send_message(event.channel.id, 'Bot is shutting down')
    exit
  end






  #Voice chat

  bot.command(:connect) do |event|
    # The `voice_channel` method returns the voice channel the user is currently in, or `nil` if the user is not in a
    # voice channel.
    channel = event.user.voice_channel
  
    # Here we return from the command unless the channel is not nil (i.e. the user is in a voice channel). The `next`
    # construct can be used to exit a command prematurely, and even send a message while we're at it.
    next "You're not in any voice channel!" unless channel
  
    # The `voice_connect` method does everything necessary for the bot to connect to a voice channel. Afterwards the bot
    # will be connected and ready to play stuff back.
    bot.voice_connect(channel)
    "Connected to voice channel: #{channel.name}"
  end
  
  # A simple command that plays back an mp3 file.
  bot.command(:play_mp3) do |event|
    # `event.voice` is a helper method that gets the correct voice bot on the server the bot is currently in. Since a
    # bot may be connected to more than one voice channel (never more than one on the same server, though), this is
    # necessary to allow the differentiation of servers.
    #
    # It returns a `VoiceBot` object that methods such as `play_file` can be called on.
    voice_bot = event.voice
    voice_bot.play_file('/home/lindgrei/Downloads/avenged_sevenfold_save_me_lyrics_70925768186194354.mp3')
  end
  
  # DCA is a custom audio format developed by a couple people from the Discord API community (including myself, meew0).
  # It represents the audio data exactly as Discord wants it in a format that is very simple to parse, so libraries can
  # very easily add support for it. It has the advantage that absolutely no transcoding has to be done, so it is very
  # light on CPU in comparison to `play_file`.
  #
  # A conversion utility that converts existing audio files to DCA can be found here: https://github.com/RaymondSchnyder/dca-rs
  bot.command(:play_dca) do |event|
    voice_bot = event.voice
  
    # Since the DCA format is non-standard (i.e. ffmpeg doesn't support it), a separate method other than `play_file` has
    # to be used to play DCA files back. `play_dca` fulfills that role.
    voice_bot.play_dca('data/music.dca')
  end

bot.run 