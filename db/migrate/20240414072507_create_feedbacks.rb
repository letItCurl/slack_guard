class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :content

      t.timestamps
    end
  end
end
