class TopController < ApplicationController

  include Const

  def show; end

  def check

    # -------------------------------------------
    # 事前処理
    # -------------------------------------------

    session[:cards] = params[:cards]
    c_chk = CardsCheck.new(params[:cards])

    # -------------------------------------------
    # カード文字列の形式チェック
    # -------------------------------------------

    schk_rslt =  c_chk.style_valid?

    msgs = []
    unless schk_rslt[:result]
      if schk_rslt[:targets].present?
        schk_rslt[:targets].each{ |target|
          msgs.push("#{target[:number]}#{MSG_WEBALT_NTH_CD_STYL}（#{target[:char]}）")
        }
        msgs.push(MSG_WEBALT_SUIT_NUM)
      else
        msgs.push(MSG_WEBALT_SPRT_SPC)
      end
      session[:hand_name] = nil
      redirect_to root_path, alert: msgs.join("\n") and return
    end

    # -------------------------------------------
    # 重複チェック
    # -------------------------------------------

    unless c_chk.uniq?
      msgs.push(MSG_WEBALT_CD_DUP)
      session[:hand_name] = nil
      redirect_to root_path, alert: msgs.join("\n") and return
    end

    # -------------------------------------------
    # 役の判定
    # -------------------------------------------

    c_chk.gen_list
    session[:hand_name] = HANDS_NAME[c_chk.check_hands]
    redirect_to root_path

  end

end
