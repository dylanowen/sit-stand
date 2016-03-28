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

    @objc func standTime() -> NSTimeInterval {
        return time(Preferences.STAND_TIME_KEY);
    }
    
    @objc func sitTime() -> NSTimeInterval {
        return time(Preferences.SIT_TIME_KEY);
    }
    
    func enabledLocations() -> [LocationProperties] {
        if let objectArray = self.settings.arrayForKey("enabledLocations") {
            if let savedLocations  = objectArray as? [LocationProperties] {
                return savedLocations
            }
        }
        
        return [LocationProperties(location: CLLocation(latitude: 37.695430, longitude: -121.923984), radius: 500)]
    }
    
    private func time(key: String) -> NSTimeInterval {
        if let savedStandTime = self.settings.stringForKey(key) {
            return NSTimeInterval(savedStandTime)!;
        }
        
        return 10; //60 * 30
    }
    
    //SINGLETON
    private init() {}
    static let get = Preferences();
}
