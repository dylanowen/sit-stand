//
//  PreferencesController.swift
//  sit-stand
//
//  Created by Dylan Owen on 3/27/16.
//
//

import Cocoa

class PreferencesController: NSViewController {

    @IBOutlet weak var sitTime: NSTextField!
    @IBOutlet weak var standTime: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sitTime.stringValue = String(Preferences.get.sitTime());

        self.standTime.stringValue = String(Preferences.get.standTime());
    }
    
    @IBAction func sitTimeChanged(sender: NSTextField) {
        print("changed");
        
        if let value = Double(sender.stringValue) {
            Preferences.get.sitTime(value);
        }
    }
    
    @IBAction func standTimeChanged(sender: NSTextField) {
        print("changed");
        
        if let value = Double(sender.stringValue) {
            Preferences.get.standTime(value);
        }
    }
}
