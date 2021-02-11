module V1

  class HandEntity < Grape::Entity
    expose :card
    expose :hand
    expose :best
  end

  class ErrorEntity < Grape::Entity
    expose :card
    expose :msg
  end

  class Cards < Grape::API

    include Const

    resource 'cards' do
      # POST /v1/cards/check
      params do
        requires :cards, type: Array
      end
      post 'check' do

        status 200
        cards = params[:cards]

        @hands = []
        @errors = []

        _cards_tmp = []
        _hands_tmp = []
        _bests_tmp = []

        cards.each{|card|

          c_chk = CardsCheck.new(card)

          # -------------------------------------------
          # カード文字列の形式チェック
          # -------------------------------------------

          schk_rslt =  c_chk.style_valid?

          unless schk_rslt[:result]

            if schk_rslt[:targets].present?
              schk_rslt[:targets].each{ |target|
                @errors.push(
                  {card: card, msg: "#{target[:number]}#{MSG_ERR_NTH_CD_STYL} (#{target[:char]})"}
                )
              }
            else
              @errors.push(
                {card: card, msg: MSG_ERR_SPRT_SPC}
              )
            end
            next
          end

          # -------------------------------------------
          # 重複チェック
          # -------------------------------------------

          unless c_chk.uniq?
            @errors.push(
              {card: card, msg: MSG_ERR_CD_DUP}
            )
            next
          end

          # -------------------------------------------
          # 役の判定
          # -------------------------------------------

          c_chk.gen_list
          hand_key = c_chk.check_hands

          _cards_tmp.push(card)
          _hands_tmp.push(hand_key)

        }

        if _hands_tmp.present?
          h_chk = HandsCheck.new(_hands_tmp)
          _bests_tmp = h_chk.best_list

          _hands_tmp.each_with_index{|_,i|
            @hands.push({card: _cards_tmp[i], hand: HANDS_NAME[_hands_tmp[i]], best: _bests_tmp[i]})
          }
        end

        present :result, @hands, with: HandEntity if @hands.present?
        present :error, @errors, with: ErrorEntity if @errors.present?

        error!({ error: [{ msg: MSG_ERR_INV_REQ}] }, 400) if @hands.blank? && @errors.blank?

      end
    end

  end

end