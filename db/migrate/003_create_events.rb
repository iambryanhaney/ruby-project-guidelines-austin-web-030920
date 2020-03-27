

class CreateEvents < ActiveRecord::Migration[5.0]
    def change
        create_table :events do |t|
            t.string :title
            t.float :price
            t.string :date
            t.string :time
            t.string :url
            t.string :image_url
        end
    end
end