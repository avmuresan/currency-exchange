require 'money/bank/open_exchange_rates_bank'

oxr = Money::Bank::OpenExchangeRatesBank.new
oxr.app_id = Rails.application.credentials[:open_exchange_app_id]
oxr.source = 'USD'
oxr.prettyprint = false
oxr.force_refresh_rate_on_expire = false

if Rails.env.test?
  oxr.cache = Rails.root.join('test/fixtures/currency-rates.json').to_s
else
  oxr.cache = Proc.new do |_text|
    Currency.rates
  end
end

Money.default_bank = oxr
