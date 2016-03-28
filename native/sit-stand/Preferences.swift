//
//  Settings.swift
//  sit-stand
//
//  Created by Dylan Owen on 3/23/16.
//
//

import Foundation
import CoreLocation

//http://stackoverflow.com/questions/2315948/how-to-store-custom-objects-in-nsuserdefaults
class Preferences {
    private static let STAND_TIME_KEY = "StandTimeKey";
    private static let SIT_TIME_KEY = "SitTimeKey";
    
    let settings = NSUserDefaults.standardUserDefaults();

    func standTime(time: Double) -> Void {
        self.settings.setDouble(time * 60, forKey: Preferences.STAND_TIME_KEY);
    }
    
    func sitTime(time: Double) -> Void {
        self.settings.setDouble(time * 60, forKey: Preferences.SIT_TIME_KEY);
    }
    
    @objc func standTime() -> NSTimeInterval {
        return time(Preferences.STAND_TIME_KEY);
    }
    
    @objc func sitTime() -> NSTimeInterval {
        return time(Preferences.SIT_TIME_KEY);
    }
    
    func enabledRegions() -> [CLCircularRegion] {
        if let objectArray = self.settings.arrayForKey("enabledLocations") {
            if let savedLocations  = objectArray as? [CLCircularRegion] {
                return savedLocations
            }
        }
        
        return [CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.695430, longitude: -121.923984), radius: 1000, identifier: "Default")]
    }
    
    private func time(key: String) -> NSTimeInterval {
        if let savedStandTime = self.settings.stringForKey(key) {
            return NSTimeInterval(savedStandTime)! / 60;
        }
        
        return 30;
    }
    
    //SINGLETON
    private init() {}
    static let get = Preferences();
}
