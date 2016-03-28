//
//  LocationProperties.swift
//  sit-stand
//
//  Created by Dylan Owen on 3/27/16.
//
//

import Foundation
import CoreLocation

class LocationProperties: NSObject, NSCoding {
    
    var location: CLLocation;
    var radius: Int;
    
    init(location: CLLocation, radius: Int) {
        self.location = location;
        self.radius = radius;

        super.init();
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.location, forKey: "location");
        coder.encodeInt(Int32(radius), forKey: "radius");
    }
    
    required init(coder decoder: NSCoder) {
        self.location = decoder.decodeObjectForKey("location") as! CLLocation
        self.radius = Int(decoder.decodeIntForKey("radius"));
    }
}