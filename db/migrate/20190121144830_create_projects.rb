class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :public_key
      t.string :secret_key

      t.timestamps
    end
  end
end
