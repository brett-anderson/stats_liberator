class AddHeightAndWeightToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :height, :string
    add_column :players, :weight, :string
  end
end
