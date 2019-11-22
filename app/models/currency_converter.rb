class CurrencyConverter
  attr_accessor :errors, :result, :date, :amount, :from, :to
  CURRENCY_SOURCE = 'USD'.freeze

  def initialize(date, amount, from, to)
    self.errors = []
    self.date = date || Time.zone.now.strftime('%Y-%m-%d')
    self.amount = amount
    self.from = from
    self.to = to

    perform_conversion
  end

  def valid?
    errors.empty?
  end

  protected

  def perform_conversion
    errors << 'Invalid date' if date.to_date < 3.months.ago
    errors << 'Invalid from currency' if Currency.all.exclude?(from)
    errors << 'Invalid to currency' if Currency.all.exclude?(to)
    return unless valid?

    update_rates(date)

    usd_amount = Money.new(amount * 100, from).exchange_to(CURRENCY_SOURCE)
    self.result = Money.new(usd_amount, CURRENCY_SOURCE).exchange_to(to)
  rescue StandardError
    errors << 'Internal error'
  end

  def update_rates(date)
    Money.default_bank.cache = proc { |_text| Currency.rates(date.to_date) }
    Money.default_bank.update_rates
  end
end
