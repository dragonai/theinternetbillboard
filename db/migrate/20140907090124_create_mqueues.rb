class CreateMqueues < ActiveRecord::Migration
  def change
    create_table :mqueues do |t|

      t.timestamps
    end
  end
end
