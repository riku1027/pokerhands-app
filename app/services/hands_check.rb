class HandsCheck

  include Const

  ORDER_TABLE = {
      HD_STRT_FLSH => 10,
      HD_4_KD => 20,
      HD_FL_HUS => 30,
      HD_FLSH => 40,
      HD_STRT => 50,
      HD_3_KD => 60,
      HD_2_PR => 70,
      HD_1_PR => 80,
      HD_HI_CD => 90
  }

  def initialize(hands)
    # カード役の配列
    @hands = hands
  end

  def best_list

    # 順位テーブルに変換
    order_list = []
    @hands.each{|hand| order_list.push(ORDER_TABLE[hand]) }

    # 最も高い役を特定
    best = order_list.min

    # 最も高い役はtrue、それ以外はfalseを設定
    best_list = []
    order_list.each { |order| best_list.push(order == best ? true : false) }

    best_list

  end

end