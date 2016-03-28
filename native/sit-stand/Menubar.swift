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
    
    private let popover = NSPopover();
    private var eventMonitor: AnyObject?;
    //private statusItemView: StatusItemView;
    
    init(sitStand: SitStand) {
        self.sitStand = sitStand;
        
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength);
        self.button = self.statusItem.button!;
        
        super.init();
        
        popover.contentViewController = PreferencesController(nibName: "PreferencesController", bundle: nil);
        
        //let sit stand know we exist
        self.sitStand.menubar = self;
        //this is Mac's fault, gestures just refuse to work
        self.button.sendActionOn(Int(NSEventMask.LeftMouseUpMask.rawValue | NSEventMask.RightMouseUpMask.rawValue));
        self.button.action = #selector(Menubar.click);
        self.button.target = self;
        
        setIcon();
    }
    
    func click(sender: AnyObject?) {
        if (NSApp.currentEvent?.type == NSEventType.RightMouseUp) {
            rightClick(sender)
        }
        else if (NSApp.currentEvent?.type == NSEventType.LeftMouseUp) {
            leftClick(sender);
        }
    }
    
    func leftClick(sender: AnyObject?) {
        if (self.popover.shown) {
            hidePopover(sender);
            
            return;
        }
        
        print("left click");
        
        self.sitStand.event();
        
        //self.button.title = SitStand.get.sitStand() ? "S" : "s";
    }
    
    func rightClick(sender: AnyObject?) {
        if (self.popover.shown) {
            hidePopover(sender);
        }
        else {
            showPopover();
        }
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
    
    private func showPopover() {
        self.popover.showRelativeToRect(self.button.bounds, ofView: self.button, preferredEdge: NSRectEdge.MinY);
        
        self.eventMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask([NSEventMask.LeftMouseDownMask, NSEventMask.RightMouseDownMask])
        {
            [unowned self] event in
            if (self.popover.shown) {
                self.hidePopover(event);
            }
        };
    }
    
    private func hidePopover(sender: AnyObject?) {
        if (self.eventMonitor != nil) {
            NSEvent.removeMonitor(self.eventMonitor!);
            
            self.eventMonitor = nil;
        }
        
        self.popover.performClose(sender);
    }
}

/*
http://stackoverflow.com/questions/32287989/nsclickgesturerecognizer-not-working-on-nsstatusitem
class StatusItemView: NSView {
    
}
 */