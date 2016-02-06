class ChangeTypeOfHtmlOnPlayer < ActiveRecord::Migration
  def up
    change_column :players, :html, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :players, :html, :string
  end 
end
