class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :label, limit: 80
      t.string :cep, limit: 8, null: false
      t.string :street, limit: 150, null: false
      t.string :number, limit: 20, null: false
      t.string :complement, limit: 100
      t.string :neighborhood, limit: 100, null: false
      t.string :city, limit: 100, null: false
      t.string :state, limit: 2, null: false
      t.string :country, limit: 60, null: false, default: "Brasil"
      t.boolean :primary, null: false, default: false

      t.timestamps
    end

    add_index :addresses, :cep
    add_index :addresses, :city
    add_index :addresses, :state
    add_index :addresses, :primary, unique: true, where: '"primary" = true', name: "index_addresses_on_single_primary"
  end
end
