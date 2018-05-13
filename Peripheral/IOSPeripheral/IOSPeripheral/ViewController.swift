//
//  ViewController.swift
//  IOSPeripheral
//
//  Created by Wilson Chang on 5/10/18.
//  Copyright © 2018 Wilson Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var switchPeripheral: UISwitch!
    var ble: BLEPeripheralManager?
    
    // Activate / disActivate the peripheral
    @IBAction func switchOnOff(_ sender: UISwitch) {
        if self.switchPeripheral.isOn {
            print("starting peripheral")
            ble = BLEPeripheralManager()
            ble!.startBLEPeripheral()
        } else {
            print("stopping peripheral")
            ble!.stopBLEPeripheral()
        }
    }
}

