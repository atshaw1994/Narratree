class CreateFlags < ActiveRecord::Migration[6.0]
  def change
    create_table :flags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :flaggable, polymorphic: true, null: false
      t.string :reason, limit: 250
      t.timestamps
    end
  end
end
