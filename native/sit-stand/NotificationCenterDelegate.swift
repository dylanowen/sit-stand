//
//  NotificationCenterDelegate.swift
//  sit-stand
//
//  Created by Dylan Owen on 3/1/16.
//
//

import Foundation

class NotificationCenterDelegate: NSObject, NSUserNotificationCenterDelegate {
    @objc func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
        //implementation
    }
    
    @objc func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        //implementation
    }
    
    @objc func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        //implementation
        return true
    }
}