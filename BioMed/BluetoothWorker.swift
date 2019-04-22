//
//  BluetoothWorker.swift
//  BioMed
//
//  Created by Darius Bogoslov on 22/04/2019.
//  Copyright © 2019 Darius Bogoslov. All rights reserved.
//

import Foundation
import CoreBluetooth

var bleDevice: BluetoothSerial!

protocol BluetoothSerialDelegate {
    // ** Required **

}

final class BluetoothSerial: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
   
    var delegate: BluetoothSerialDelegate!
    var manager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic: CBCharacteristic!
    var deviceName: String = ""
    
    init(delegate: BluetoothSerialDelegate) {
        super.init()
        self.delegate = delegate
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth not available.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData advertismentData: [String: Any], rssi RSSI: NSNumber) {
        
        if(peripheral.name == deviceName) {
            self.peripheral = peripheral
            manager.stopScan()
            manager.cancelPeripheralConnection(peripheral)
            manager.connect(self.peripheral, options: nil)
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        switch peripheral.state {
        case CBPeripheralState.connected:
            print("\nConnected to: \(String(describing: peripheral.name))!", terminator: "")
        case CBPeripheralState.connecting:
            print("\nReconnecting...", terminator: "");
        case CBPeripheralState.disconnected:
            print("\nDisconnected", terminator: "");
        default:
            print("Could not connect to device");
        }
        
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "FFE0")])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print ("\nAll services found: \n\(String(describing: peripheral.services))\n", terminator: "");
        
        for svc:CBService in peripheral.services! {
            print("Service: \(svc)\n", terminator: "")
            peripheral.discoverCharacteristics([CBUUID(string: "FFE1")], for: svc)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if(error != nil) {
            return
        }
        
        let currentCharacterisic = service.characteristics![0]
        print("\nCharacteristic: \n\(currentCharacterisic) \n", terminator: "")
        characteristic = service.characteristics![0]
        peripheral.setNotifyValue(true, for: characteristic)
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let string = String(data: characteristic.value!, encoding: String.Encoding.ascii)
        print(string as Any)
        
    }
    
    func sendToBLE(_ text:String) {
        let data = (text as NSString).data(using: String.Encoding.utf8.rawValue)
        peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
    }
}
