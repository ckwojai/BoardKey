//
//  BLECentralManager.swift
//  MacCentral
//
//  Created by Wilson Chang on 5/13/18.
//  Copyright © 2018 Wilson Chang. All rights reserved.
//

import Foundation
import CoreBluetooth
let IosKeyboardServiceCBUUID = CBUUID(string: "AA40E3C9-D777-4B2B-8A4F-9B78B1E8D605")
let IosKeyboardReadCharCBUUID = CBUUID(string: "5FF12413-BC42-4B51-ACBE-EEB5B305B468")
let IosKeyboardWriteCharCBUUID = CBUUID(string: "6682C4F0-61EF-473F-9329-B2BE9875911D")
class BLECentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var localCentralManager: CBCentralManager!
    var localCentral: CBCentral!
    var localPeripheral: CBPeripheral!
    var delegate: BLEPeripheralProtocol?
    // =================
    // Delegate Methods
    // =================
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState")
        if central.state == .poweredOn {
            print("Scanning for peripherals")
            central.scanForPeripherals(withServices: [IosKeyboardServiceCBUUID])
        } else {
            print("cannot create services. state = " + self.getState(central: central))
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        localPeripheral = peripheral
        localPeripheral.delegate = self
        localCentralManager.stopScan()
        localCentralManager.connect(localPeripheral)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to service\(String(describing: peripheral.services?.description))")
        localPeripheral.discoverServices([IosKeyboardServiceCBUUID])
    }
    // ========================
    // Extension for Peripheral
    // ========================
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case IosKeyboardReadCharCBUUID:
            print("Read Char")
            print(characteristic.value!.utf8String!)
            let ch: String = characteristic.value!.utf8String!
            executeKeypress(value: ch)
            // delegate?.logToScreen(text: ch)
        case IosKeyboardWriteCharCBUUID:
            print("Write Char")
            print(characteristic.value!)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    // =============
    // Tools
    // =============
    func startBLECentral() {
        print("startBLECentral")
        // delegate?.logToScreen(text: "startBLECentral")
        // start the Bluetooth periphal manager
        localCentralManager = CBCentralManager(delegate: self, queue: nil)
    }
    func stopBLECenral() {
        // MARK: need fix
        print("stopBLECentral")
        //self.localPeripheralManager.removeAllServices()
        //self.localPeripheralManager.stopAdvertising()
    }
    func getState(central: CBCentralManager) -> String {
        switch central.state {
        case .unknown:
            return "unknown"
        case .resetting:
            return "resetting"
        case .unsupported:
            return "unsupported"
        case .unauthorized:
            return "unauthorized"
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        }
    }
}
extension Data {
    var utf8String: String? {
        return string(as: .utf8)
    }
    func string(as encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
}
