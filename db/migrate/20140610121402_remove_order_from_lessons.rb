class RemoveOrderFromLessons < ActiveRecord::Migration
  def change
    remove_column :lessons, :order, :integer
  end
end
