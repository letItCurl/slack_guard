class Campaign < ApplicationRecord
  MAX_EMAILS_NUMBER = 50
  belongs_to :user

  validates :name, presence: true
  validates :emails, presence: true
  validate :max_emails
  enum status: { started: "started", done: "done", failed: "failed" }

  after_create :send_campaign

  def emails_list
    emails.split(",").map(&:strip).uniq.compact
  end

  private

  def send_campaign
    Campaigns::SendJob.perform_async(self.id)
  end

  def max_emails
    if emails_list.size > Campaign::MAX_EMAILS_NUMBER
      errors.add(:base, "Maximum numbers of emails: #{Campaign::MAX_EMAILS_NUMBER}")
    end
  end
end
