class CallLog < ApplicationRecord
  validates :phone_number, presence: true
  
  scope :successful, -> { where(status: 'completed') }
  scope :failed, -> { where(status: ['failed', 'busy', 'no-answer', 'canceled']) }
  scope :in_progress, -> { where(status: ['queued', 'ringing', 'in-progress']) }
  
  def self.stats
    {
      total: count,
      successful: successful.count,
      failed: failed.count,
      in_progress: in_progress.count,
      average_duration: where(status: 'completed').average(:duration).to_f.round(2)
    }
  end
end