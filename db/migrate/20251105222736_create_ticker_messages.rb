class CreateTickerMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :ticker_messages do |t|
      t.text :message

      t.timestamps
    end
  end
end
