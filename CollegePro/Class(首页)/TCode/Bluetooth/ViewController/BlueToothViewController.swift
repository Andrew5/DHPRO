//
//  BlueToothViewController.swift
//  CollegePro
//
//  Created by jabraknight on 2019/10/10.
//  Copyright © 2019 jabrknight. All rights reserved.
//

//import Foundation
import UIKit
class BlueToothViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLECentralManager.shareInstance()?.startScan()
        BLECentralManager.shareInstance()?.setDeviceScanBlock({ (device) in
            
            print(device?.peripheral.name as Any)
            if device?.peripheral.identifier.uuidString == "82FE86CC-0788-67BE-A6D7-AB3B84760C4D" {
                BLECentralManager.shareInstance()?.stopScan()
                BLECentralManager.shareInstance()?.beginConnect(with: device?.peripheral)
            }
        })
        //        BLECentralManager.shareInstance()?.setDeviceScanCompletionBlock({ (services) in
        //        })
        BLECentralManager.shareInstance().setStateChangedBlock({ (bleState) in
            
        })
        BLECentralManager.shareInstance()?.setConnectedCompletionBlock({ (peripheral) in
            print("success Connected");
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                //                let dataa = [0x6F,0x06,0x00,0xFF,0xB0,0x00,0x04,0xFC,0xDE]
                //                let byte = [UInt8](dataa)
                let byte:[UInt8] = [0x6F,0x06,0x00,0xFF,0xB0,0x00,0x04,0xFC,0xDE]
                _ = Data(bytes: byte, count: byte.count)
                //                let byte = [0x0a,0x0d]
                //                 BLECentralManager.shareInstance()?.getFirstConnector()?.send(data)
                BLECentralManager.shareInstance()?.getFirstConnector()?.sendMessage("atz/r")
                print("send data success ...");
            })
        })
        BLECentralManager.shareInstance()?.setDisConnect({ (peripheral, error) in
            print("DisConnect..");
        })
        
        BLECentralManager.shareInstance()?.setConnectFailedBlock({ (peripheral, error) in
            print("fail..");
        })
        
        BLECentralManager.shareInstance()?.getFirstConnector()?.setReceivePartialDataBlock({ (data) in
            print("Receive data ...");
        })
        
    }
    
    
}
