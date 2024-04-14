class Campaign < ApplicationRecord
  validates :name, presence: true
  validates :emails, presence: true
  enum status: { started: "started", done: "done", failed: "failed" }

  def emails_list
    emails.split(",").each(&:strip)
  end
end
