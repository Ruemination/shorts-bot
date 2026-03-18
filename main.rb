require 'discordrb'
require 'mini_magick'

class Bot
    def initialize
        @token = JSON.parse(File.read('token.json'))
        @bot = Discordrb::Commands::CommandBot.new(
            token: @token['token'],
            prefix: '!',
            intents: [:server_messages, :server_emojis, :server_message_reactions, :server_members]
        )
        commands
        @bot.run
    end

    def commands
        @bot.command(:ping) do |event|
            event.respond "Pong!"
        end

        @bot.message do |event|
            puts "Received message: #{event.content}"
        end

        @bot.command(:txt) do |event, *message|
            message = message.join(" ")
            file_name = rand(1..100000000).to_s
            File.write("#{file_name}.txt", message)
            event.channel.send_file(File.open("#{file_name}.txt", 'rb'), caption: "Here's your text file")
            if File.exist?("#{file_name}.txt")
                File.delete("#{file_name}.txt")
            end
            return nil
        end

        @bot.command(:beauty_filter) do |event|
            unless event.message.attachments.empty?
                attachment = event.message.attachments.first
                if attachment.filename.downcase.end_with?('.jpg', '.jpeg', '.png', '.gif')
                    image_data = URI.open(attachment.url)
                    image = MiniMagick::Image.read(image_data)
                    image.quality(2)
                    image.depth(2)
                    image.interlace("Plane")
                    image.contrast
                    image.blur("2x2")
                    temp = "temp_image.jpg"
                    image.write(temp)
                    event.channel.send_file(File.open(temp, 'rb'), caption: "")
                    File.delete(temp)
                end
            end
            return nil
        end

        @bot.reaction_add do |event, reaction|
            puts "#{event.user.name} reacted with #{event.emoji.name} on message #{event.message.id}"
            message = event.channel.load_message(event.message.id)
            if event.emoji.name == "6️⃣"
                message.react("7️⃣")
            end
        end

        @bot.command(:open_image) do |event, *message|
            message = message.join(" ")
            loading_array = [":white_large_square:", ":white_large_square:", ":white_large_square:", ":white_large_square:", ":white_large_square:", ":white_large_square:", ":white_large_square:", ":white_large_square:", ":white_large_square:", ":white_large_square:"]
            index = 0
            event.respond "Searching for file at #{message}"
            if File.exists?("#{message}")
                cache = event.respond "File found! Starting decryption process\n#{loading_array.join("")}"
                while index < 10
                    loading_array.delete_at(index)
                    loading_array.insert(index, ":white_check_mark:")
                    cache.edit(content="File found! Starting decryption process\n#{loading_array.join("")}")
                    index += 1
                    sleep 1
                end
                snafu(event, message)
                #event.channel.send_file(File.open(message, "rb"), caption: "Decryption finished")
                #sleep 2
                #cache.edit(content="File found! Starting decryption process\n#{loading_array.join("")}")
            else

            end
        end
    end
end

def snafu(event, message)
    image_data = File.open(message, "rb")
    image = MiniMagick::Image.read(image_data)
    image.resize("500x500")
    2.times do |points|
        points = snafu_gen
        image.distort(:Perspective, points.join(' '))
    end
    image.swirl(swirl_value)
    temp = "temp_image2.jpg"
    image.write(temp)
    event.channel.send_file(File.open(temp, 'rb'), caption: "**Decryption succeeded at #{rand(80..95).to_s}%**")
    File.delete(temp)
    nil
end

def snafu_gen
    snafu_array = []
    1.times do |x|
        x = rand(500)
        y = rand(500)
        z = x + rand(-1..1)
        a = y + rand(-1..1)
        b = rand(150..250)
        c = rand(150..250)
        d = b + rand(-1..1)
        e = c + rand(-1..1)
        f = rand(250..350)
        g = rand(250..350)
        h = f + rand(-1..1)
        i = g + rand(-1..1)
        j = rand(350..450)
        k = rand(350..450)
        l = j + rand(-1..1)
        m = k + rand(-1..1)
        snafu_array.push(x,y,z,a,b,c,d,e,f,g,h,i,j,k,l,m)
    end
    return snafu_array
end

def swirl_value
    rand(-180..180)
end

def amp
    rand(-150..150)
end

def an_determiner(n)
    case n
    when "11"
        return "an"
    when "18"
        return "an"
    else
        n = n.split("")
        if n[0] == "8"
            return "an"
        else
            return "a"
        end
    end
end


Bot.new