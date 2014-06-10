class RemoveColumn < ActiveRecord::Migration
  def change
    remove_column :lessons, :order
  end
end
