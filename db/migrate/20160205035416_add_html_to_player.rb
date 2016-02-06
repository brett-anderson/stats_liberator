class AddHtmlToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :html, :string
  end
end
