class Api::CurrencyConverterControllerTest < ActionDispatch::IntegrationTest
  test 'should sanitize the parameters before calculating the result' do
    result = Money.new(100_12, 'USD')
    CurrencyConverter.expects(:new).with('2010-11-12', 100.12, 'USD', 'RON')
                     .returns(OpenStruct.new(valid?: true, result: result))

    get api_path(amount: '100.12', from: 'usd', to: 'ron', date: '2010-11-12')
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal result.to_f.round(4), json_response['result']
  end

  test 'should respond with the errors when conversion fails' do
    errors = ['error 1', 'error 2']
    CurrencyConverter.expects(:new).with('2010-11-12', 100.12, 'KKK', 'RON')
                     .returns(OpenStruct.new(valid?: false, errors: errors))

    get api_path(amount: '100.12', from: 'KKK', to: 'ron', date: '2010-11-12')
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal errors, json_response['errors']
  end
end
