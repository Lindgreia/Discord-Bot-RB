require 'discordrb'
config = File.foreach('/home/lindgrei/github/Gemstone/config.txt').map { |line| line.split(' ').join(' ')}
token = config[0].to_s
bot = Discordrb::Commands::CommandBot.new token: "#{token}", prefix: "gem@", client_id:"#{config[1].to_s}"

#On console:

puts "Bot is up and running!"
puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'


#Welcoming
EMOTE = "\u2764"
bot.message(content: "Hello!") do |event|
  event.message.react(EMOTE)
end

bot.member_join do |event|
  bot.send_message(event.channel.id, 'Welcome', event.author.mention)
end

bot.mention do |event|
  event.author.mention
end

bot.command(:exit, help_available: false) do |event|
    # This is a check that only allows a user with a specific ID to execute this command. Otherwise, everyone would be
    # able to shut your bot down whenever they wanted.
    break unless event.user.id == 703997865982165442 # Replace number with your ID

    bot.send_message(event.channel.id, 'Bot is shutting down')
    exit
  end


bot.run



bot.run
