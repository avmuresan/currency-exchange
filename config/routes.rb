Rails.application.routes.draw do
  root to: 'pages#app'
  get '*path', to: 'pages#app', constraints: lambda { |req|
    [
      '/api'
    ].none? { |p| req.path.start_with?(p) }
  }

  namespace :api do
    get 'convert/:amount/:from/to/:to', controller: :currency_converter,
                                        action: :convert,
                                        constraints: { amount: /\d.*/ }
  end
end
