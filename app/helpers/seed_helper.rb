module SeedHelper
  def initial_data
    result = {}
    result['environment'] = { env: Rails.env }
    result['currencies'] = Currency.all
    result.to_json
  end
end
