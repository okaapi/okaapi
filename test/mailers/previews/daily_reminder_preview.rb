# Preview all emails at http://localhost:3000/rails/mailers/daily_reminder
class DailyReminderPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daily_reminder/send_reminder
  def send_reminder
    DailyReminder.send_reminder
  end

end
