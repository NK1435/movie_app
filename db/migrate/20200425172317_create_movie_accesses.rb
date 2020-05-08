class CreateMovieAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_accesses do |t|
      t.string :title
      t.integer :movie_id

      t.timestamps
    end
  end
end
