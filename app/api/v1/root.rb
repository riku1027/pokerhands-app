module V1
  class Root < Grape::API

    include Const

    version 'v1'
    format :json

    rescue_from :all do |e|
      error!({ error: [{ msg: MSG_ERR_SYS_ERR}] }, 500)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({ error: [{ msg: MSG_ERR_INV_REQ}] }, 400)
    end

    # Each APIs
    mount V1::Cards

    route :any, '*path' do
      error!({ error: [{ msg: MSG_ERR_INV_URL}] }, 404)
    end

  end
end
