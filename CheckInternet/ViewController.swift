//
//  ViewController.swift
//  CheckInternet
//
//  Created by Burak GÖKÇINAR on 22.04.2017.
//  Copyright © 2017 SkyPlane. All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    @IBOutlet weak var myLabel: UILabel!
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        if isConnectedToNetwork() == true
        {
            myLabel.text = "Connected Network"
        }
        else
        {
            myLabel.text = "Not Connected Network"
        }
    }
    
    
    func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress)
        {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
            {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false
        {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }



}

