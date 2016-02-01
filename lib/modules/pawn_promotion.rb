module PawnPromotion
  def promote
        puts 'Promote your peasant, what piece do you want?'
        case input = gets.chomp
        when 'QUEEN'  then @active_player.promote_to(:queen)
        when 'KNIGHT' then @active_player.promote_to(:knight)
        when 'ROOK'   then @active_player.promote_to(:rook)
        when 'BISHOP' then @active_player.promote_to(:bishop)
        else puts 'Incorrect, try again'; promote
        end
    end

    def pawn_promotion
      @active_player.pieces.select { |piece| piece.figure == :pawn }.any? { |pawn| pawn.promote == true }
    end
end