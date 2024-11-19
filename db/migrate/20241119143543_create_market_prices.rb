class CreateMarketPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :market_prices do |t|
      t.datetime :time
      t.decimal :value, precision: 9, scale: 2

      t.timestamps
    end
  end
end
