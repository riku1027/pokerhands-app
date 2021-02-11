require 'rails_helper'


include Const

describe 'Cards Check' do

  describe 'Style Check' do

    it "5つの文字列の半角スペース区切りでない" do
      card_chk = CardsCheck.new("S1H2 D4C5 S13")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq([])
    end

    it "1番目のカード文字列が不正" do
      card_chk = CardsCheck.new("s1 H2 D4 C5 S13")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq([{number: 1, char: "s1"}])
    end

    it "2番目のカード文字列が不正" do
      card_chk = CardsCheck.new("S1 A2 D4 C5 S13")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq([{number: 2, char: "A2"}])
    end

    it "3番目のカード文字列が不正" do
      card_chk = CardsCheck.new("S1 H2 DD4 C5 S13")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq([{number: 3, char: "DD4"}])
    end

    it "4番目のカード文字列が不正" do
      card_chk = CardsCheck.new("S1 H2 D4 あい S13")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq([{number: 4, char: "あい"}])
    end

    it "5番目のカード文字列が不正" do
      card_chk = CardsCheck.new("S1 H2 D4 C5 S99")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq([{number: 5, char: "S99"}])
    end

    it "1番目と4番目のカード文字列が不正" do
      card_chk = CardsCheck.new("~ H2 D4 * S9")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq([{number: 1, char: "~"}, {number: 4, char: "*"}])
    end

    it "全てのカード文字列が不正" do
      card_chk = CardsCheck.new("A B C D E")
      style_chk_rslt = card_chk.style_valid?
      expect(style_chk_rslt[:result]).to eq(false)
      expect(style_chk_rslt[:targets]).to eq(
        [{number: 1, char: "A"}, {number: 2, char: "B"}, {number: 3, char: "C"}, {number: 4, char: "D"}, {number: 5, char: "E"}]
      )
    end

  end

  describe 'Uniq Check' do

    it "1番目と2番目のカード文字列が重複" do
      card_chk = CardsCheck.new("H1 H1 S2 S3 C4")
      expect(card_chk.uniq?).to eq(false)
    end

    it "1番目と3番目と5番目のカード文字列が重複" do
      card_chk = CardsCheck.new("S2 H7 S2 S3 S2")
      expect(card_chk.uniq?).to eq(false)
    end

    it "全てのカード文字列が重複" do
      card_chk = CardsCheck.new("H7 H7 H7 H7 H7")
      expect(card_chk.uniq?).to eq(false)
    end

  end

  describe 'Hands' do

    it "Straight flush" do

      ["S","H","D","C"].each{ |s|

        # 2〜9始まり
        2.upto(9){|i|
          cards = "#{s}#{i} #{s}#{i+1} #{s}#{i+2} #{s}#{i+3} #{s}#{i+4}"
          card_chk = CardsCheck.new(cards)
          card_chk.gen_list
          expect(card_chk.check_hands).to eq(HD_STRT_FLSH)
        }
        # 1始まり
        card_chk = CardsCheck.new("#{s}1 #{s}2 #{s}3 #{s}4 #{s}5")
        card_chk.gen_list
        expect(card_chk.check_hands).to eq(HD_STRT_FLSH)
        # 10始まり
        card_chk = CardsCheck.new("#{s}10 #{s}11 #{s}12 #{s}13 #{s}1")
        card_chk.gen_list
        expect(card_chk.check_hands).to eq(HD_STRT_FLSH)

      }

    end

    it "Four of a kind" do
      1.upto(13){|i|
        cards = "S#{i} H#{i} D#{i} C#{i} H#{i==13 ? i-1 : i+1}"
        card_chk = CardsCheck.new(cards)
        card_chk.gen_list
        expect(card_chk.check_hands).to eq(HD_4_KD)
      }
    end

    it "Full house" do

      cards = "S2 H2 S3 H3 D3"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_FL_HUS)

      cards = "S13 H13 D13 H1 D1"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_FL_HUS)

    end

    it "Flush" do

      ["S","H","D","C"].each{ |s|
        cards = "#{s}1 #{s}3 #{s}5 #{s}7 #{s}13"
        card_chk = CardsCheck.new(cards)
        card_chk.gen_list
        expect(card_chk.check_hands).to eq(HD_FLSH)
      }

    end

    it "Straight" do

      # 2〜9始まり
      2.upto(9){|i|
        cards = "S#{i} H#{i+1} D#{i+2} C#{i+3} S#{i+4}"
        card_chk = CardsCheck.new(cards)
        card_chk.gen_list
        expect(card_chk.check_hands).to eq(HD_STRT)
      }
      # 1始まり
      card_chk = CardsCheck.new("S1 H2 D3 C4 S5")
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_STRT)
      # 10始まり
      card_chk = CardsCheck.new("S10 H11 D12 C13 S1")
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_STRT)

    end

    it "Three of a kind" do

      cards = "S2 H1 S3 H3 D3"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_3_KD)

      cards = "S13 H13 D13 H2 D1"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_3_KD)

    end

    it "Two Pair" do

      cards = "S2 H2 S3 H3 D1"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_2_PR)

      cards = "S13 H13 D2 H2 D1"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_2_PR)

    end

    it "One Pair" do

      cards = "S2 H2 S3 H5 D1"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_1_PR)

      cards = "S13 H13 D7 H2 D1"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_1_PR)

    end

    it "High Card" do

      cards = "S2 H7 S1 H13 D9"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_HI_CD)

      cards = "S11 H13 D3 H2 D1"
      card_chk = CardsCheck.new(cards)
      card_chk.gen_list
      expect(card_chk.check_hands).to eq(HD_HI_CD)

    end

  end


end