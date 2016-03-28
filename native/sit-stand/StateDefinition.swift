//
//  StateDefinition.swift
//  sit-stand
//
//  Created by Dylan Owen on 3/27/16.
//
//

import Foundation

struct StateDefinition {
    let name: String;
    let notificationText: String;
    let getInterval: () -> NSTimeInterval;
    
    init(name: String, notificationText: String, getInterval: () -> NSTimeInterval) {
        self.name = name;
        self.notificationText = notificationText;
        self.getInterval = getInterval;
    }
}