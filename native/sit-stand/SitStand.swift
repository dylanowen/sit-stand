//
//  SitStand.swift
//  sit-stand
//
//  Created by Dylan Owen on 3/26/16.
//
//

import Foundation



//private typealias GetTimeInterval = () -> NSTimeInterval;

class SitStand {
    private static let SittingDefinition = StateDefinition(
        name: "Sitting",
        notificationText: "Sit Down",
        getInterval: { return Preferences.get.sitTime() }
    );
    private static let StandingDefinition = StateDefinition(
        name: "Standing",
        notificationText: "Stand Up",
        getInterval: { return Preferences.get.standTime() }
    );
    private static let PausedDefinition = StateDefinition(
        name: "Paused",
        notificationText: "",
        getInterval: { return 0 }
    );
    
    internal enum State {
        case SITTING
        case STANDING
        case PAUSED
        
        var value: StateDefinition {
            switch self {
            case .SITTING:
                return SittingDefinition;
            case .STANDING:
                return StandingDefinition;
            case .PAUSED:
                return PausedDefinition;
            }
        }
        
        private var inverse: State {
            switch self {
            case .SITTING:
                return .STANDING;
            case .STANDING:
                return .SITTING;
            case .PAUSED:
                return .PAUSED;
            }
        }
    }
    
    var timer: NSTimer?;
    var currentState: State = .PAUSED;
    var menubar: Menubar?;
    
    init() {
    }
    
    func event(notify: Bool = true) -> Void {
        clearTimers();
        
        //don't do anything if we're paused
        if (self.currentState == .PAUSED) {
            return;
        }
        
        self.currentState = self.currentState.inverse;
        
        if (notify) {
            let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter();
            notificationCenter.removeAllDeliveredNotifications()
            
            let notification:NSUserNotification = NSUserNotification()
            notification.title = self.currentState.value.notificationText;
            //notification.
            //notification.subtitle = "Subtitle"
            //notification.informativeText = self.currentState.value.notificationText
            
            //notification.soundName = NSUserNotificationDefaultSoundName
            notificationCenter.deliverNotification(notification)
        }
        
        menubar?.setIcon();
        
        startTimer();
    }
    
    @objc func timerEvent() -> Void {
        event();
    }
    
    func pause() -> Void {
        clearTimers();
        
        self.currentState = .PAUSED;
    }
    
    func unPause() -> Void {
        //if we're not paused continue as normal
        if (self.currentState != .PAUSED) {
            return;
        }
        
        self.currentState = .STANDING;
        
        event(false);
    }
    
    private func startTimer() -> Void {
        let interval: NSTimeInterval = self.currentState.value.getInterval()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(SitStand.timerEvent), userInfo: nil, repeats: false)
    }
    
    private func clearTimers() -> Void {
        if (self.timer != nil) {
            self.timer?.invalidate();
        }
        
        self.timer = nil;
    }
}