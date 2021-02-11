class ApiErrorsController < ActionController::Base

  include Const

  def parse_error()
    # JSONのパースエラー
    render json: { error: [{ msg: MSG_ERR_INV_REQ}] }, status: 400
  end

  def dispatch_error()
    # その他のミドルウェア例外
    render json: { error: [{ msg:MSG_ERR_SYS_ERR}] }, status: 500
  end
end