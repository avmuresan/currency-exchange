module ApplicationHelper
  def initial_data
    result = {}
    result['environment'] = { env: Rails.env }
    result.to_json
  end
end
