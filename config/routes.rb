Rails.application.routes.draw do

  # Web
  root 'top#show'
  put '/check', to: 'top#check'

  # API
  mount API::Root => '/api'

  get '*path', to: 'application#render_404'

end
