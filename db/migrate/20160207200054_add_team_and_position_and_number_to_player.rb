class AddTeamAndPositionAndNumberToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :team, :string
    add_column :players, :number, :integer
    add_column :players, :position, :string
  end
end
