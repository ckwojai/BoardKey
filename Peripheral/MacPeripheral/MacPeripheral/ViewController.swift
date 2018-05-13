//
//  ViewController.swift
//  MacPeripheral
//
//  Created by Wilson Chang on 5/12/18.
//  Copyright © 2018 Wilson Chang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var ble: BLEPeripheralManager?
    @IBOutlet weak var peripheralSwitch: NSButton!
    @IBAction func switchPeripheralOnOff(_ sender: NSButton) {
        if self.peripheralSwitch.state == .on {
            print("starting peripheral")
            ble = BLEPeripheralManager()
            ble!.startBLEPeripheral()
        } else {
            print("stopping peripheral")
            ble!.stopBLEPeripheral()
        }
    }
    
}

