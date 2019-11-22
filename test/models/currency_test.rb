require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  class AllMethod < ActiveSupport::TestCase
    setup do
      Rails.cache.clear
    end

    test 'should retrieve all currencies using a single rates call' do
      rates = Rails.root.join('test/fixtures/currency-rates.json').read
      Currency.expects(:rates).returns(rates)
      rates_hash = JSON.parse(rates)
      assert_equal rates_hash['rates'].keys, Currency.all

      Currency.expects(:rates).never
      assert_equal rates_hash['rates'].keys, Currency.all
    end

    test 'should respond with an empty array when an error is raised' do
      Currency.expects(:rates).raises(StandardError)
      assert_equal [], Currency.all
    end
  end

  class RatesMethod < ActiveSupport::TestCase
    setup do
      Rails.cache.clear
    end

    test 'should retrieve all currencies using a single rates call' do
      dummy_url = 'http://dummy.url'
      Currency.expects(:rates_url).with(Time.zone.now.strftime('%Y-%m-%d'))
              .returns('http://dummy.url')

      rates = Rails.root.join('test/fixtures/currency-rates.json').read
      response = OpenStruct.new(read: rates)
      Currency.expects(:open).with(dummy_url).returns(response)

      assert_equal response.read, Currency.rates

      Currency.expects(:open).never
      assert_equal response.read, Currency.rates
    end

    test 'should retrieve all date currencies using a single rates call' do
      dummy_url = 'http://dummy.url'
      date = Time.zone.now - 3.days
      Currency.expects(:rates_url).with(date.strftime('%Y-%m-%d'))
          .returns('http://dummy.url')

      rates = Rails.root.join('test/fixtures/currency-rates.json').read
      response = OpenStruct.new(read: rates)
      Currency.expects(:open).with(dummy_url).returns(response)

      assert_equal response.read, Currency.rates(date)

      Currency.expects(:open).never
      assert_equal response.read, Currency.rates(date)
    end

    test 'should raise exception when something is wrong' do
      Currency.expects(:open).raises(StandardError)
      assert_raise(StandardError) { Currency.rates }
    end
  end

  class RatesUrlMethod < ActiveSupport::TestCase
    test 'should respond a custom rates url' do
      app_id = 123
      date = '2010-11-12'
      Money.expects(:default_bank).returns(OpenStruct.new(app_id: app_id))
      expected_url = "#{Currency::RATES_URL}/#{date}.json?app_id=#{app_id}"
      assert_equal expected_url, Currency.rates_url(date)
    end
  end
end
