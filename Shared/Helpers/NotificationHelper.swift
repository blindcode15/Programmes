import Foundation
import UserNotifications

public enum NotificationHelper {
    public static func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            return false
        }
    }

    public static func scheduleDaily(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("REMINDER_TITLE", comment: "")
        content.body = NSLocalizedString("REMINDER_BODY", comment: "")
        content.sound = .default

        var date = DateComponents()
        date.hour = hour
        date.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "mood.daily.reminder", content: content, trigger: trigger)

        center.add(request)
    }
}