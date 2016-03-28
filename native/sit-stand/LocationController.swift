//
//  LocationManager.swift
//  sit-stand
//
//  Created by Dylan Owen on 3/23/16.
//
//

import Foundation
import CoreLocation

class LocationController: CLLocationManager, CLLocationManagerDelegate {
    
    private let sitStand: SitStand;
    
    init(sitStand: SitStand) {
        self.sitStand = sitStand;
        
        super.init();
        
        self.delegate = self;
        self.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.distanceFilter = 300; //meters
        
        preferencesUpdate();
    }
    
    func preferencesUpdate() {
        if (Preferences.get.enabledLocations().count > 0) {
            startUpdatingLocation();
        }
        else {
            stopUpdatingLocation();
            //we're only paused if we're not in the right location, but it's set for all locations
            self.sitStand.unPause();
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if let clErr = CLError(rawValue: error.code) {
            print(error.localizedDescription);
            
            switch clErr {
                case .LocationUnknown:
                    //something went wrong so keep looking for new locations
                    break;
                case .Denied:
                    //we don't have permissions to use location so all locations are valid
                    self.sitStand.unPause();
                default:
                    //don't care
                    break;
            }
        }
        else {
            print("Unknown error");
        }
    }
    
    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        let validLocations = Preferences.get.enabledLocations();
        let currentLocation = manager.location!
        
        for locationProperty in validLocations {
            print(locationProperty.location.distanceFromLocation(currentLocation));
            
            if (Int(locationProperty.location.distanceFromLocation(currentLocation)) < locationProperty.radius) {
                self.sitStand.unPause();
                
                return;
            }
        }
        
        self.sitStand.pause();
    }
}
