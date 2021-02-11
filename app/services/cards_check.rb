class CardsCheck

  include Const

  def initialize(cards)

    # カード文字列
    @cards = cards

    # 数値カウント格納用ハッシュの初期化
    @n_cnt_hash = {}
    13.times{|n| @n_cnt_hash.store((n+1).to_s, 0)}
    # @n_list.store(0, 0)

    # スートカウント格納用ハッシュの初期化
    @s_cnt_hash = {}
    [S_SPD, S_HRT, S_DYA, S_CLB].each{|s| @s_cnt_hash.store(s, 0)}
    # ["S","H","D","C", "N"].each{|s| @s_cnt_hash.store(s, 0)}

  end


  # @param str カード文字列
  # @param number カード枚数
  # @return {result: true or false, targets: [{number: Int, char: String}]} チェック結果（真偽値と対象カード番号のハッシュ）
  # @note カード文字列の形式チェック（半角スペース区切り）
  def style_valid?(number=5)

    reg_str = ""
    number.times{ |n|
      reg_str += '[\S]+' # Any non-whitespace character
      reg_str += SEPARATE_CHAR unless n == number-1
    }

    return {result: false, targets: []} unless @cards =~ /\A#{reg_str}\z/

    # 分割してチェック
    cards_list = @cards.split(SEPARATE_CHAR)

    targets = []
    cards_list.each_with_index { |card, i|
      targets.push({number: i+1, char: cards_list[i]}) unless card =~ /\A#{REG_CARD_STYLE}\z/
    }

    targets.present? ? {result: false, targets: targets} : {result: true, targets: []}

  end

  # @return 真偽値
  # @note カードに重複が無いかをチェックする
  def uniq?
    cards_list = @cards.split(SEPARATE_CHAR)
    cards_list.uniq == cards_list
  end

  # @note 数値とスートのカウント表を作成
  def gen_list
    @cards.split(SEPARATE_CHAR).each { |card|
      @n_cnt_hash[(card[1,card.length-1]).to_s] += 1
      @s_cnt_hash[(card[0,1]).to_s] += 1
    }
  end

  # @return 役の名前
  # @note 役のチェック
  def check_hands

    # ストレートかチェック
    straight_flg = straight?

    # フラッシュかチェック
    flush_flg = flush?

    if straight_flg
      return flush_flg ? HD_STRT_FLSH : HD_STRT
    end

    if flush_flg
      return HD_FLSH
    end

    # ペア数をチェック
    pair_cnt_hash = count_pairs

    if pair_cnt_hash["4"] == 1 && pair_cnt_hash["1"] == 1
      return HD_4_KD
    end

    if pair_cnt_hash["3"] == 1 && pair_cnt_hash["2"] == 1
      return HD_FL_HUS
    end

    if pair_cnt_hash["3"] == 1 && pair_cnt_hash["1"] == 2
      return HD_3_KD
    end

    if pair_cnt_hash["2"] == 2 && pair_cnt_hash["1"] == 1
      return HD_2_PR
    end

    if pair_cnt_hash["2"] == 1 && pair_cnt_hash["1"] == 3
      return HD_1_PR
    end

    HD_HI_CD

  end

  private

  # @return 真偽値
  # @note ストレートかどうかを判定
  def straight?

    n_list = []
    @n_cnt_hash.each{|k,v|
      return false if v > 1
      n_list.push(k.to_i) if v == 1
    }

    n_list.sort!
    n_max = n_list.max
    n_min = n_list.min
    n_sum = n_list.inject(:+)

    if n_min == 1

      # --------------------------
      # 一致ケース
      # --------------------------
      # [1,2,3,4,5] -> 10
      # [1,10,11,12,13] -> 47
      # --------------------------

      return false unless (n_list == [1,2,3,4,5] || n_list == [1,10,11,12,13])

    else

      # --------------------------
      # [2,3,4,5,6] -> 20
      # [3,4,5,6,7] -> 25
      # [4,5,6,7,8] -> 30
      # [5,6,7,8,9] -> 35
      # [6,7,8,9,10] -> 40
      # [7,8,9,10,11] -> 45
      # [8,9,10,11,12] -> 50
      # [9,10,11,12,13] -> 55
      # --------------------------

      return false unless n_max - n_min == 4 # [9,*,*,*,13] -> *
      return false unless (n_max + n_min) / 2 == n_list[2] # [9,*,11,*,13] -> *
      return false unless n_sum % 5 == 0 # [9,9,11,13,13] -> 55, [9,10,11,12,13] -> 55, [9,11,11,11,13] -> 55
      return false unless n_list.size == n_list.uniq.size # [9,10,11,12,13] -> 55

    end

    true

  end

  # @return 真偽値
  # @note フラッシュかどうかを判定
  def flush?
    @s_cnt_hash.each{|_,v|
      return true if v == 5
    }
    false
  end

  # @return 数値シンボルをキーとしたペア数のハッシュ
  # @note 含まれるペア数を判定
  def count_pairs

    pair_cnt_hash = {"4" => 0, "3"=> 0, "2"=> 0, "1"=> 0 }
    @n_cnt_hash.each {|_,v|
      pair_cnt_hash[v.to_s] += 1 if v > 0
    }

    pair_cnt_hash

  end

end