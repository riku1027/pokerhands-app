require 'rails_helper'

include Const

describe 'Hands Check' do

  # ------------------------
  # Hand         | Order
  # ------------------------
  # HD_STRT_FLSH | 10
  # HD_4_KD      | 20
  # HD_FL_HUS    | 30
  # HD_FLSH      | 40
  # HD_STRT      | 50
  # HD_3_KD      | 60
  # HD_2_PR      | 70
  # HD_1_PR      | 80
  # HD_HI_CD     | 90
  # ------------------------

  describe '#best_list' do

    it "役が１つだけ" do
      h_chk = HandsCheck.new([HD_STRT_FLSH])
      expect(h_chk.best_list).to eq([true])
    end

    it "役が複数、ベストが1つだけ" do
      h_chk = HandsCheck.new([HD_4_KD, HD_FL_HUS, HD_3_KD])
      expect(h_chk.best_list).to eq([true, false, false])
    end

    it "役が複数、ベストが複数" do
      h_chk = HandsCheck.new([HD_STRT_FLSH, HD_STRT_FLSH, HD_4_KD, HD_STRT_FLSH, HD_HI_CD, HD_1_PR])
      expect(h_chk.best_list).to eq([true, true, false, true, false, false])
    end

    it "役が複数、全てがベスト" do
      h_chk = HandsCheck.new([HD_3_KD, HD_3_KD, HD_3_KD, HD_3_KD])
      expect(h_chk.best_list).to eq([true, true, true, true])
    end

  end



end