class CreateNurses < ActiveRecord::Migration
  def change
    create_table :nurses do |t|

      t.timestamps null: false
    end
  end
end
