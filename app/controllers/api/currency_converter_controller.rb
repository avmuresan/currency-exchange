class Api::CurrencyConverterController < ApplicationController
  before_action :override_format

  def convert
    converter = CurrencyConverter.new(*currency_params)
    if converter.valid?
      render json: { result: converter.result.to_f.round(4) }
    else
      render json: { errors: converter.errors }, status: :unprocessable_entity
    end
  end

  protected

  def currency_params
    [params[:date], params[:amount].to_f,
     params[:from].upcase, params[:to].upcase]
  end

  def override_format
    request.format = :json
  end
end
