class Campaign < ApplicationRecord
  MAX_EMAILS_NUMBER = 50
  MAX_FREE_CREDITS = 15
  belongs_to :user

  validates :name, presence: true
  validates :emails, presence: true
  validate :max_emails
  validate :max_free_credits
  enum status: { started: "started", done: "done", failed: "failed" }

  after_create :send_campaign

  def emails_list
    emails.split(",").map(&:strip).uniq.compact
  end

  private

  def send_campaign
    Campaigns::SendJob.perform_later(self.id)
  end

  def max_emails
    if emails_list.size > Campaign::MAX_EMAILS_NUMBER
      errors.add(:base, "Maximum numbers of emails: #{Campaign::MAX_EMAILS_NUMBER}")
    end
  end

  def max_free_credits
    if user.campaigns.count >= Campaign::MAX_FREE_CREDITS
      errors.add(:base, "No more credits in your account. Top-up your credits to send more campaigns")
    end
  end
end
