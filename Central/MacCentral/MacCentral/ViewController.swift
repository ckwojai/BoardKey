//
//  ViewController.swift
//  MacCentral
//
//  Created by Wilson Chang on 5/13/18.
//  Copyright © 2018 Wilson Chang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var centralSwitch: NSButton!
    var ble: BLECentralManager?
    
    @IBAction func centralSwitchOnOff(_ sender: NSButton) {
        if centralSwitch.state == .on {
            print("Starting peripheral")
            ble = BLECentralManager()
            ble!.startBLECentral()
        } else {
            ble!.startBLECentral()
        }
    }
}

