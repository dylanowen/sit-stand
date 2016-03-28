//
//  AppDelegate.swift
//  sit-stand
//
//  Created by Dylan Owen on 2/29/16.
//
//

import Cocoa
import CoreLocation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var notificationCenterDelegate: NotificationCenterDelegate? = nil;
    
    var sitStand: SitStand? = nil;
    var locationController: LocationController? = nil;
    
    
    var menubar: Menubar? = nil;
    

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        notificationCenterDelegate = NotificationCenterDelegate();
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = notificationCenterDelegate;
        
        self.sitStand = SitStand();
        
        self.locationController = LocationController(sitStand: self.sitStand!);
        self.menubar = Menubar(sitStand: self.sitStand!);
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        self.sitStand = nil;
        
        self.locationController = nil;
        self.menubar = nil;
    }
}

