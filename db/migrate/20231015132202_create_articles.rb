class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.string :code
      t.decimal :price
      t.decimal :promo_price
      t.boolean :on_promo

      t.timestamps
    end
  end
end
