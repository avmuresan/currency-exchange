module SeedHelper
  def initial_data
    result = {}
    result['environment'] = { env: Rails.env }
    result['currencies'] = filtered_currencies
    result.to_json
  end

  SAMPLE_CURRENCIES = %w(EUR USD GBP RON HUF NOK JPY).freeze

  def filtered_currencies
    Currency.all.select { |currency| SAMPLE_CURRENCIES.include?(currency) }
  end
end
