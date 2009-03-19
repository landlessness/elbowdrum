# **************************
# RSS feed from EdgeoftheCloud.com
# Adpated by Henry P by Brian M.
# **************************
require 'net/http'
require 'rexml/document'

answer

wait(1000)

class EdgeOfTheCloud

    def getFeed
        res = Net::HTTP.start('edgeofthecloud.com') {|http|
	        http.get('/?feed=rss2')
        }
        result = REXML::Document.new(res.body)
        @titles = []
        @descriptions = []
        result.elements.each('rss/channel/item/description') do |ele|
            @descriptions << ele.text
        end
        result.elements.each('rss/channel/item/title') do |ele|
            @titles << ele.text
        end
    end

    def playFeed
        say ("There are #{@titles.size} thoughts.  Press 1 to move to the next thought.  Press 2 to go back to the previous though.  Press 3 to repeat the title of a thought.   Press 4 to listen to the full thought.  Press 0 to end.")

        detail = false
        currentIndex = 0
        while currentIndex < @titles.size
            option = 'next'
            if detail == true
                result=prompt("#{@descriptions[currentIndex]}",
                {'silenceTimeout'=> 1,
                 'choices'=> "next(1, next), previous(2, previous), repeat(3, repeat), detail(4, detail), end(0, end)",
                 'maxTime'=>30,
                 'timeout'=>1.203456789,
                 'onChoice'=>lambda { |event| option = event.value },
                 'onEvent'=>lambda { |event|
                      event.onTimeout( lambda { option = 'next' } )
                      event.onHangup( lambda { option = 'end' } )
                      event.onBadChoice( lambda { say "bad choice" } )}
                })
            else
                result=prompt("#{@titles[currentIndex]}",
                {'silenceTimeout'=> 1,
                 'choices'=> "next(1, next), previous(2, previous), repeat(3, repeat), detail(4, detail), end(0, end)",
                 'maxTime'=>30,
                 'timeout'=>1.203456789,
                 'onChoice'=>lambda { |event| option = event.value },
                 'onEvent'=>lambda { |event|
                      event.onTimeout( lambda { option = 'next'} )
                      event.onHangup( lambda { option = 'end' } )
                      event.onBadChoice( lambda { say "bad choice" } )}
                })
            end
            
            if result.name == 'hangup'
                break
            end
            
            case option
                when 'next'
                    # next - skip to the next headline
                    currentIndex += 1
                    detail = false
                when 'previous'
                    # previous - go back to the previous headline
                    if currentIndex > 0
                        currentIndex -= 1
                    end
                    detail = false
                when 'detail'
                    # detail - play detail headline
                    detail = true
                when 'repeat'
                    # repeat - repeat the headline
                when 'end'
                    break
            else
                #  default - break
                break
            end
            
            wait(1000)
        end
    end
end    

say("Welcome to Edge of the Cloud, thoughts from Chet Kapoor, CEO of Sonoa Systems.")

say("Please wait while we retrieve Chet's latest thoughts")

f1 = EdgeOfTheCloud.new()
f1.getFeed
f1.playFeed

hangup