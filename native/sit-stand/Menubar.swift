//
//  MenubarController.swift
//  sit-stand
//
//  Created by Dylan Owen on 2/29/16.
//
//

import Foundation
import AppKit

let STATUS_ITEM_VIEW_WIDTH = 24.0;

//https://github.com/inderdhir/SwiftWeather
//https://github.com/devxoul/allkdic/blob/6745251f4d779e39f41f835b9395bb0cad74d745/Allkdic/Controllers/PopoverController.swift
//http://footle.org/WeatherBar/
//https://github.com/yene/Simple-Duration/blob/master/Simple%20Duration/AppDelegate.swift
//https://github.com/NSRover/NinjaMode/blob/master/NinjaMode/AppDelegate.m
class Menubar: NSObject {
    
    private let statusItem: NSStatusItem;
    private let button: NSStatusBarButton;
    private let sitStand: SitStand;
    //private statusItemView: StatusItemView;
    
    init(sitStand: SitStand) {
        self.sitStand = sitStand;
        
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1);
        self.button = self.statusItem.button!;
        
        super.init();
        
        //let sit stand know we exist
        self.sitStand.menubar = self;
        
        self.button.action = #selector(Menubar.leftClick);
        self.button.target = self;
        
        //add right click
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x2 // right mouse
        gesture.target = self
        gesture.action = #selector(Menubar.rightClick);
        self.button.addGestureRecognizer(gesture)
        
        setIcon();
    }
    
    func leftClick() {
        print("left click");
        
        self.sitStand.event();
        
        //self.button.title = SitStand.get.sitStand() ? "S" : "s";
    }
    
    func rightClick() {
        print("right click");
    }
    
    func setIcon() {
        switch self.sitStand.currentState {
        case .SITTING:
            self.button.title = "s";
        case .STANDING:
            self.button.title = "S";
        case .PAUSED:
            self.button.title = "P";
        }
        
        self.button.toolTip = self.sitStand.currentState.value.name;
    }
}