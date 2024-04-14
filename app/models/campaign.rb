class Campaign < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :emails, presence: true
  enum status: { started: "started", done: "done", failed: "failed" }

  after_create :send_campaign

  def emails_list
    emails.split(",").map(&:strip)
  end

  private

  def send_campaign
    Campaigns::SendJob.perform_async(self.id)
  end
end
