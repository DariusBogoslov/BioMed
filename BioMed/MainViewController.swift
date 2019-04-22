//
//  MainViewController.swift
//  BioMed
//
//  Created by Darius Bogoslov on 20/04/2019.
//  Copyright © 2019 Darius Bogoslov. All rights reserved.
//
import UIKit
import Foundation
import CoreBluetooth

class MainViewController: UIViewController, BluetoothSerialDelegate {
    
    @IBOutlet weak var bleDeviceName: UITextField!
    
    @IBAction func connectToDevice(_ sender: UIButton) {
        if(bleDeviceName.text!.count > 0 || bleDeviceName.text != nil)
        {
            bleDevice = BluetoothSerial(delegate: self)
            bleDevice.deviceName = bleDeviceName.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
}
