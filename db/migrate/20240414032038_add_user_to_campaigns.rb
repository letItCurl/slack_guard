class AddUserToCampaigns < ActiveRecord::Migration[7.1]
  def change
    add_reference :campaigns, :user, null: false, foreign_key: true, type: :uuid
  end
end
