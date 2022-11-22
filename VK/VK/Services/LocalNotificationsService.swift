import UIKit
import UserNotifications

class LocalNotificationsService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = LocalNotificationsService()
    
    func registerForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        registerUpdatesCategory()
    
        center.requestAuthorization(options: [.sound, .badge, .provisional]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Напоминание"
                content.body = "Посмотрите последние обновления"
                content.categoryIdentifier = "updates"
                
                var dateComponents = DateComponents()
                dateComponents.hour = 19
                dateComponents.minute = 0
                
                let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let requset = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triger)
                center.add(requset)
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    func registerUpdatesCategory() {
        let center = UNUserNotificationCenter.current()
        
        let actionShow = UNNotificationAction(identifier: "delete", title: "Удалить", options: .destructive)
        let category = UNNotificationCategory(identifier: "updates", actions: [actionShow], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "delete":
            print("удалено")
        default:
            print("unrecognised action identifier")
        }
        completionHandler()
    }
    
    /// Use shared property instead
    private override init() {
        super.init()
    }
}
