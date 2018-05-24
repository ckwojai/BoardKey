//
//  ViewController.swift
//  MacCentral
//
//  Created by Wilson Chang on 5/13/18.
//  Copyright © 2018 Wilson Chang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var logTextView: NSScrollView!
    @IBOutlet weak var centralSwitch: NSButton!
    var ble: BLECentralManager?
    
    override func viewDidLoad() {
        print("Starting peripheral")
        ble = BLECentralManager()
        // ble?.delegate = self
        ble!.startBLECentral()
    }
//    @IBAction func centralSwitchOnOff(_ sender: NSButton) {
//        if centralSwitch.state == .on {
//            print("Starting peripheral")
//            ble = BLECentralManager()
//            ble?.delegate = self
//            ble!.startBLECentral()
//        } else {
//            ble!.startBLECentral()
//        }
//    }
//    func logToScreen(text: String) {
//        print("Inside logToScreen")
//        logTextView.documentView?.insertText(text)
//    }
}

