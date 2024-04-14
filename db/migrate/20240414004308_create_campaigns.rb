class CreateCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :campaigns, id: :uuid do |t|
      t.string :name
      t.text :emails
      t.text :message
      t.string :status, default: "started"

      t.timestamps
    end
  end
end
