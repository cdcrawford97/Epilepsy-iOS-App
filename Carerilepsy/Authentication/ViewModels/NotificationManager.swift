//
//  NotificationManager.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 23/07/2021.
//

import Foundation
import UserNotifications
import Firebase

final class NotificationManager: ObservableObject {
    
    @Published var authorizationStatus: UNAuthorizationStatus?
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    func notificationAuthStatus() {
        
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    
    func requestNotificationAuth() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = success ? .authorized : .denied
            }
        }
    }
    
    func createLocalNotification(uuid: String, title: String, subtitle: String, body: String, hour: Int, minute: Int, weekday: Int, completion: @escaping (Error?) -> Void) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        // Gregorian Calendar, 1 for sunday 2 for monday etc..
        // if not set, will recur everyday
        dateComponents.weekday = weekday
        
        // Create the trigger as a repeating event
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //Configuring the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the request
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        // Schedule the request with the system
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
    func createLocalNotificationDaily(uuid: String, title: String, subtitle: String, body: String, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create the trigger as a repeating event
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //Configuring the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the request
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        // Schedule the request with the system
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
    
    
    func deleteLocalNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    
    // debugging function
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }

    
    
    
}
