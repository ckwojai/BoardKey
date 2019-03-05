//
//  BLEPeripheralManager.swift
//  IOSPeripheral
//
//  Created by Wilson Chang on 5/11/18.
//  Copyright © 2018 Wilson Chang. All rights reserved.
//

import Foundation
import CoreBluetooth
// UUID of peripheral service, and characteristics
// can be generated using "uuidgen" under osx console

let peripheralName = "Awesome_M117"
// Service
let BLEService = "AA40E3C9-D777-4B2B-8A4F-9B78B1E8D605" // generic service
// Characteristics
let CH_READ  = "5FF12413-BC42-4B51-ACBE-EEB5B305B468"
let CH_WRITE = "6682C4F0-61EF-473F-9329-B2BE9875911D"

let TextToAdvertise = "Wilson is awesome! Meow~"    // < 28 bytes needed.
var TextToNotify = "Notification: "                 // < 28 bytes needed ???

class BLEPeripheralManager: NSObject, CBPeripheralManagerDelegate {
    var localPeripheralManager: CBPeripheralManager!
    var localPeripheral: CBPeripheral?
    var createdService = [CBService]()
    var keyboardState = "idle" {
        didSet {
            self.localPeripheralManager.updateValue(keyboardState.data(using: String.Encoding.utf8)!, for: createdService[0].characteristics![0] as! CBMutableCharacteristic, onSubscribedCentrals: nil)
        }
    }
    // I don't know what these are
    var notifyCharac: CBMutableCharacteristic? = nil
    var notifyCentral: CBCentral? = nil
    // timer used to retry to scan for peripheral, when we don't find it
    var notifyValueTimer: Timer?

    // ==================
    // Delegate stud
    // ==================
    // Receive bluetooth state
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState")
        if peripheral.state == .poweredOn {
            self.createServices()
        } else {
            print("cannot create services. state = " + self.getState(peripheral: peripheral))
        }
    }
    // Service + Characteristic added to peripheral
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?){
        print("peripheralManager didAdd service")
        if error != nil {
            print(("Error adding services: \(String(describing: error?.localizedDescription))"))
        }
        else {
            print("service:\n" + service.uuid.uuidString)
            // Create an advertisement, using the service UUID
            let advertisement: [String : Any] = [CBAdvertisementDataServiceUUIDsKey : [service.uuid], CBAdvertisementDataLocalNameKey: peripheralName]
            //CBAdvertisementDataLocalNameKey: peripheralName]
            //28 bytes maxu !!!
            // only 10 bytes for the name
            // https://developer.apple.com/reference/corebluetooth/cbperipheralmanager/1393252-startadvertising
            
            // start the advertisement
            print("Advertisement datas: ")
            print(String(describing: advertisement))
            self.localPeripheralManager.startAdvertising(advertisement)
            print("Starting to advertise.")
        }
    }
    // When Notification
    // When Central manager send read request
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
        print("peripheralManager didReceiveRead")
        print("request uuid: " + request.characteristic.uuid.uuidString)
        
        // prepare advertisement data
        let data: Data = keyboardState.data(using: String.Encoding.utf8)!
        request.value = data //characteristic.value
        // Respond to the request
        localPeripheralManager.respond(to: request, withResult: .success)
        
        // acknowledge : ok
        peripheral.respond(to: request, withResult: CBATTError.success)
    }
    // When Central manager send write request
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("peripheralManager didReceiveWrite")
        for r in requests {
            print("request uuid: " + r.characteristic.uuid.uuidString)
        }
        if requests.count > 0 {
            let str = NSString(data: requests[0].value!, encoding:String.Encoding.utf16.rawValue)!
            print("value sent by central Manager :\n" + String(describing: str))
        }
        peripheral.respond(to: requests[0], withResult: CBATTError.success)
    }
    // Advertising Done
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?){
        if error != nil {
            print(("peripheralManagerDidStartAdvertising Error :\n \(String(describing: error?.localizedDescription))"))
        }
        else {
            print("peripheralManagerDidStartAdvertising OK")
        }
    }
    
    func respond(to request: CBATTRequest, withResult result: CBATTError.Code) {
        print("respnse requested")
    }
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheral name changed")
    }
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("peripheral service modified")
    }
    // When Central subscribes to a characteristics
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("peripheralManager didSubscribeTo characteristic :\n" + characteristic.uuid.uuidString)
    }
    // ========================
    // Self defined fucntions
    // ========================
    func startBLEPeripheral() {
        print("startBLEPeripheral")
        print("Discoverable name : " + peripheralName)
        print("Discoverable service :\n" + BLEService)
        // start the Bluetooth periphal manager
        localPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    func stopBLEPeripheral() {
        print("stopBLEPeripheral")
        self.localPeripheralManager.removeAllServices()
        self.localPeripheralManager.stopAdvertising()
    }
    func createServices() {
        print("Create service...")
        // service
        let serviceUUID = CBUUID(string: BLEService)
        let service = CBMutableService(type: serviceUUID, primary: true)
        // characteristic
        var chs = [CBMutableCharacteristic]()
        // Read characteristic
        print("Charac. read : \n" + CH_READ)
        let characteristic1UUID = CBUUID(string: CH_READ)
        let properties: CBCharacteristicProperties = [.read, .notify ]
        let permissions: CBAttributePermissions = [.readable]
        let ch = CBMutableCharacteristic(type: characteristic1UUID, properties: properties, value: nil, permissions: permissions)
        chs.append(ch)
        // Write characteristic
        print("Charac. write : \n" + CH_WRITE)
        let characteristic2UUID = CBUUID(string: CH_WRITE)
        let properties2: CBCharacteristicProperties = [.write, .notify ]
        let permissions2: CBAttributePermissions = [.writeable]
        let ch2 = CBMutableCharacteristic(type: characteristic2UUID, properties: properties2, value: nil, permissions: permissions2)
        chs.append(ch2)
        // Create the service, add the characteristic to it
        service.characteristics = chs
        createdService.append(service)
        localPeripheralManager.add(service)
    }
    // ====================
    // Tools
    // ====================
    func getState(peripheral: CBPeripheralManager) -> String {
        switch peripheral.state {
        case .poweredOn:
            return "poweredOn"
        case .poweredOff:
            return "poweredOff"
        case .resetting:
            return "resetting"
        case .unauthorized:
            return "unauthorized"
        case .unknown:
            return "unknown"
        case .unsupported:
            return "unsupported"
        }
    }
}










