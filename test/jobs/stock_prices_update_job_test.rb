require "test_helper"

class StockPricesUpdateJobTest < ActiveJob::TestCase
  STOCK_URL_MATCHER = %r{https://www\.alphavantage\.co/query\?apikey=asdf&function=GLOBAL_QUOTE&symbol=[A-Z]+}
  STOCK_SYMBOLS = ["KO", "SNE", "TWX", "DIS", "SIRI", "F", "EA", "FB", "UA", "LUV", "GPS"]

  setup do
    stub_request(:get, STOCK_URL_MATCHER)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Host" => "www.alphavantage.co",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body: "", headers: {})
  end

  test "makes API calls" do
    StockPricesUpdateJob.perform_now
    assert_requested :get, STOCK_URL_MATCHER, times: 11
  end

  test "creates Stock records" do
    skip("waiting for implementation")

    assert_difference("Stock.count", 11) do
      StockPricesUpdateJob.perform_now
    end
  end

  test "sets Stock ticker and price" do
    skip("waiting for implementation")

    StockPricesUpdateJob.perform_now
    STOCK_SYMBOLS.each do |ticker|
      stock = Stock.find_by(ticker: ticker)
      assert stock.present?
      assert stock.price.present?
    end
  end
end
