require 'test_helper'

class CurrencyConverterTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
  end

  test 'should make the conversion for 3 days ago' do
    date = 3.days.ago.strftime('%Y-%m-%d')
    rates = Rails.root.join('test/fixtures/currency-rates.json').read
    rates_json = JSON.parse(rates)
    Currency.stubs(:all).returns(rates_json['rates'].keys)
    Currency.stubs(:rates).with(date.to_date).returns(rates)
    converter = CurrencyConverter.new(date, 100, 'EUR', 'RON')
    assert converter.valid?

    usd_amount = Money.new(100 * 100, 'EUR')
      .exchange_to(CurrencyConverter::CURRENCY_SOURCE)
    result = Money.new(usd_amount, CurrencyConverter::CURRENCY_SOURCE)
      .exchange_to('RON')
    assert_equal result.to_f, converter.result.to_f
  end

  test 'should make the conversion for today' do
    date = Time.zone.now.strftime('%Y-%m-%d')
    rates = Rails.root.join('test/fixtures/currency-rates.json').read
    rates_json = JSON.parse(rates)
    Currency.stubs(:all).returns(rates_json['rates'].keys)
    Currency.stubs(:rates).with(date.to_date).returns(rates)
    converter = CurrencyConverter.new(nil, 100, 'EUR', 'RON')
    assert converter.valid?

    usd_amount = Money.new(100 * 100, 'EUR')
                     .exchange_to(CurrencyConverter::CURRENCY_SOURCE)
    result = Money.new(usd_amount, CurrencyConverter::CURRENCY_SOURCE)
                 .exchange_to('RON')
    assert_equal result.to_f, converter.result.to_f
  end

  test 'should be invalid when date is older than 3 months' do
    date = (3.months.ago - 1.day).strftime('%Y-%m-%d')
    rates = Rails.root.join('test/fixtures/currency-rates.json').read
    rates_json = JSON.parse(rates)
    Currency.stubs(:all).returns(rates_json['rates'].keys)
    Currency.expects(:rates).never
    converter = CurrencyConverter.new(date, 100, 'EUR', 'RON')
    assert_not converter.valid?
    assert_equal ['Invalid date'], converter.errors
  end

  test 'should be invalid when from currency is invalid' do
    date = Time.zone.now.strftime('%Y-%m-%d')
    Currency.stubs(:all).returns(['USD'])
    Currency.expects(:rates).never
    converter = CurrencyConverter.new(date, 100, 'EUR', 'USD')
    assert_not converter.valid?
    assert_equal ['Invalid from currency'], converter.errors
  end

  test 'should be invalid when to currency is invalid' do
    date = Time.zone.now.strftime('%Y-%m-%d')
    Currency.stubs(:all).returns(['USD'])
    Currency.expects(:rates).never
    converter = CurrencyConverter.new(date, 100, 'USD', 'EUR')
    assert_not converter.valid?
    assert_equal ['Invalid to currency'], converter.errors
  end

  test 'should be invalid when an error is raised' do
    date = Time.zone.now.strftime('%Y-%m-%d')
    rates = Rails.root.join('test/fixtures/currency-rates.json').read
    rates_json = JSON.parse(rates)
    Currency.stubs(:all).returns(rates_json['rates'].keys)
    Currency.stubs(:rates).with(date.to_date).returns(rates)
    Money.any_instance.stubs(:exchange_to).raises(StandardError)
    converter = CurrencyConverter.new(date, 100, 'EUR', 'RON')
    assert_not converter.valid?
    assert_equal ['Internal error'], converter.errors
  end
end
