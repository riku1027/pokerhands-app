module Const

  # ------------------------------------
  # カード役
  # ------------------------------------

  # HD_RYL_STRT_FLSH = X
  HD_STRT_FLSH = '10'
  HD_4_KD = '20'
  HD_FL_HUS = '30'
  HD_FLSH = '40'
  HD_STRT = '50'
  HD_3_KD = '60'
  HD_2_PR = '70'
  HD_1_PR = '80'
  HD_HI_CD = '90'

  HANDS_NAME = {
      # HD_RYL_STRT_FLSH => 'Royal Straight flush',
      HD_STRT_FLSH => I18n.t("hands.hd_strt_flsh"),
      HD_4_KD => I18n.t("hands.hd_4_kd"),
      HD_FL_HUS => I18n.t("hands.hd_fl_hus"),
      HD_FLSH => I18n.t("hands.hd_flsh"),
      HD_STRT => I18n.t("hands.hd_strt"),
      HD_3_KD => I18n.t("hands.hd_3_kd"),
      HD_2_PR => I18n.t("hands.hd_2_pr"),
      HD_1_PR => I18n.t("hands.hd_1_pr"),
      HD_HI_CD => I18n.t("hands.hd_hi_cd")
  }

  # ------------------------------------
  # スート
  # ------------------------------------

  S_SPD = "S"
  S_HRT = "H"
  S_DYA = "D"
  S_CLB = "C"
  # S_NON = "N"

  # ------------------------------------
  # メッセージ
  # ------------------------------------

  # API
  MSG_ERR_INV_REQ = '不正なリクエストです。'
  MSG_ERR_INV_URL  = '不正なURLです。'
  MSG_ERR_SYS_ERR = 'システムエラーが発生しました。'

  MSG_ERR_SPRT_SPC = '5つのカード指定文字を半角スペース区切りで入力してください。'
  MSG_ERR_NTH_CD_STYL = '番目のカード指定文字が不正です。'
  MSG_ERR_CD_DUP = 'カードが重複しています。'

  # Web
  MSG_WEBALT_INV_URL = '不正なURLです。'
  MSG_WEBALT_SYS_ERR = 'システムエラーが発生しました。'

  MSG_WEBALT_NTH_CD_STYL = '番目のカード指定文字が不正です。'
  MSG_WEBALT_SUIT_NUM = '半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。'
  MSG_WEBALT_SPRT_SPC = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
  MSG_WEBALT_CD_DUP  = "カードが重複しています。"

  # ------------------------------------
  # その他
  # ------------------------------------

  SEPARATE_CHAR = " "
  REG_CARD_STYLE = "[#{S_SPD}#{S_HRT}#{S_DYA}#{S_CLB}]([1-9]|1[0-3])"

end