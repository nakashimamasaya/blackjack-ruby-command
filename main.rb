class BlackJackDeck
    def initialize
        @r = Random.new
        @number_card = 52
        @card = [true] * @number_card
    end
    
    def draw_card
        num = @r.rand(0..51)
        while !@card[num]
            num = @r.rand(0..51)
        end
        if @card[num]
            @card[num] = false
            return num % 13 + 1
        end
    end
    
    def remain_number
        return @card.count(true)
    end
end

class Player
    def initialize
        @hands = []
        @card = [*1..10, 'J', 'Q', 'K']
    end
    
    def get_hand(card)
        @hands.push(card)
    end
    
    def open_hands
        return @hands.map{|hand| @card[hand-1]}.join(' ')
    end
    
    def dealer_hands
        return @card[@hands[0]-1].to_s + ' #'
    end
    
    def count_hands
        return @hands.length
    end
    
    def view_point
        ace = false
        result = 0
        @hands.each do |hand|
            if hand == 1
                ace = true
            end
            result += [hand, 10].min
        end
        
        if ace && result +10 <= 21
            result += 10
        end
        
        return result
    end
end

class BlackJack
    def initialize
        @deck = BlackJackDeck.new()
        @player = Player.new()
        @dealer = Player.new()
    end
    
    def start_game
        2.times do
            @player.get_hand(@deck.draw_card)
            @dealer.get_hand(@deck.draw_card)
        end 
        
        puts 'ディーラーの手札はこちら'
        puts @dealer.dealer_hands
        
        puts 'プレイヤーの手札はこちら'
        puts @player.open_hands
    end
    
    def tarn_game
        puts '現在のプレイヤーの手札はこちら'
        puts @player.open_hands
        
        print 'カードを引く：0　カードを引かない:1  >'
        input_num = gets.chomp
        while !(input_num == '0' || input_num == '1')
            print 'カードを引く：0　カードを引かない:1  >'
            input_num = gets.chomp
        end
        
        if input_num == '0' 
            draw = @deck.draw_card
            puts '引いたカードはこちら　' + draw.to_s
            @player.get_hand(draw)
        end
        
        return @player.view_point <= 21 && input_num == '0'
    end
    
    def end_game
        puts "--------------------------------\n結果発表"
        while @dealer.view_point < 17
            @dealer.get_hand(@deck.draw_card)
        end
        
        puts 'ディーラーの手札はこちら'
        puts @dealer.open_hands + '　ポイント：' + @dealer.view_point.to_s
        
        puts 'プレイヤーの手札はこちら'
        puts @player.open_hands + '　ポイント：' + @player.view_point.to_s
        
    end
    
    def result_game
        player_point = @player.view_point < 22 ? @player.view_point : 0
        dealer_point = @dealer.view_point < 22 ? @dealer.view_point : 0
        
        
        win = player_point > dealer_point || 
            (player_point == dealer_point && player_point== 21 && 
            @player.count_hands == 2 && @dealer.count_hands != 2)
        draw = player_point == dealer_point
        
        if win
            puts "プレイヤーの勝利"
        elsif draw
            puts "引き分け"
        else
            puts "プレイヤーの負け"
        end
        puts ""
    end

    def continue_game
        puts "続けてやりますか？ はい:0 いいえ:1  >"
        input = gets.chomp
        while !(input == '0' || input == '1')  
            puts "続けてやりますか？ はい:0 いいえ:1  >"
            input = gets.chomp
        end
        return input == '0'
    end
    
    def main_game
        start_game
        while tarn_game
        end
        end_game
        result_game
        return continue_game
    end
end

while BlackJack.new().main_game
end


