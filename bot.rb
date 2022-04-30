require 'discordrb'

bot = Discordrb::Commands::CommandBot.new token: 'BOT_TOKEN_HERE', prefix: '!' 

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


  bot.command(:eval, help_available: false) do |event, *code|
    break unless event.user.id == 703997865982165442 # Replace number with your ID
  
    begin
      eval code.join(' ')
    rescue StandardError
      'An error occurred 😞'
    end
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
  



#GUESS NUMBER

bot.message(start_with: '!game') do |event|
  # Pick a number between 1 and 10
  magic = rand(1..10)

  # Tell the user that we're ready.
  event.respond "Can you guess my secret number? It's between 1 and 10!"

  # Await a MessageEvent specifically from the invoking user.
  # Timeout defines how long a user can spend playing one game.
  # This does not affect subsequent games.
  #
  # You can omit the options hash if you don't want a timeout.
  event.user.await!(timeout: 300) do |guess_event|
    # Their message is a string - cast it to an integer
    guess = guess_event.message.content.to_i

    # If the block returns anything that *isn't* true, then the
    # event handler will persist and continue to handle messages.
    if guess == magic
      # This returns `true`, which will destroy the await so we don't reply anymore
      guess_event.respond 'you win!'
      true
    else
      # Let the user know if they guessed too high or low.
      guess_event.respond(guess > magic ? 'too high' : 'too low')

      # Return false so the await is not destroyed, and we continue to listen
      false
    end
  end
  event.respond "My number was: `#{magic}`."
end


# the unicode ":x:" emoji
CROSS_MARK = "\u274c"

bot.message(content: '!time') do |event|
  # Send a message, and store a reference to it that we can add the reaction.
  message = event.respond "The current time is: #{Time.now.strftime('%F %T %Z')}"

  # React to the message to give a user an easy "button" to press
  message.react CROSS_MARK

  # Add an await for a ReactionAddEvent, that will only trigger for reactions
  # that match our CROSS_MARK emoji. To prevent the bot from cluttering up threads, we destroy the await after 30 seconds.
  bot.add_await!(Discordrb::Events::ReactionAddEvent, message: message, emoji: CROSS_MARK, timeout: 30) do |_reaction_event|
    message.delete # Delete the bot message
  end
  # This code executes after our await concludes, or when the timeout runs out.
  # For demonstration purposes, it just prints "Await destroyed.". In your actual code you might want to edit the message or something alike.
  puts 'Await destroyed.'
end


bot.run 
