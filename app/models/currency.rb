require 'open-uri'

class Currency
  CURRENCIES_URL = 'https://openexchangerates.org/api/currencies.json'.freeze
  RATES_URL = 'https://openexchangerates.org/api/historical'.freeze

  def self.all
    Rails.cache.fetch('currencies') do
      JSON.parse(rates)['rates'].keys
    end
  rescue StandardError => e
    Rails.logger.debug(e.message)
    []
  end

  def self.rates(date = Time.zone.now)
    formatted_date = date.strftime('%Y-%m-%d')
    Rails.cache.fetch("rates-#{formatted_date}") do
      open(rates_url(formatted_date)).read # rubocop:disable Security/Open
    end
  end

  def self.rates_url(formatted_date)
    "#{RATES_URL}/#{formatted_date}.json?app_id=#{Money.default_bank.app_id}"
  end
end
