class AddYahooIdToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :yahoo_id, :integer
  end
end
