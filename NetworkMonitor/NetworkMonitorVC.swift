//
//  NetworkMonitorVC.swift
//  NetworkMonitor
//
//  Created by Awais Akram on 28.4.2021.
//

import UIKit
import Network

class NetworkMonitorVC: UIViewController, NetworkCheckObserver {
    
    
    //MARK:- Variables
    var networkChecker = NetworkChecker.sharedInstance()
    
    //MARK:- UI ELement Outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var conTypeLabel: UILabel!
    
    //MARK:- View Loads
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNetworkStateUI(networkPath: networkChecker.currentConnectionDetails)
        networkChecker.addObserver(observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // networkChecker.removeObserver(observer: self)
        super.viewWillDisappear(animated)
    }
    
    func updateNetworkStateUI(networkPath: NWPath) {
        let networkStatus = networkPath.status
        
        let isWifi: Bool = networkPath.usesInterfaceType(.wifi)
        let isCellular: Bool = networkPath.usesInterfaceType(.cellular)
        
        let iswiredEthernet: Bool = networkPath.usesInterfaceType(.wiredEthernet)
        let isloopback: Bool = networkPath.usesInterfaceType(.loopback)
        let isother: Bool = networkPath.usesInterfaceType(.other)
        
       
        
        if networkStatus == .unsatisfied {
            statusLabel.textColor = .red
            statusLabel.text = "Disconnected"
            conTypeLabel.text = "-"
        }
        else if networkStatus == .requiresConnection {
            statusLabel.textColor = .orange
            statusLabel.text = "Searching..."
            conTypeLabel.text = "-"
        }
        else {
            statusLabel.textColor = .systemGreen
            statusLabel.text = "Connected!"
            
            if isWifi {
                conTypeLabel.text = "Wi-Fi"
            }
            else if isCellular {
                conTypeLabel.text = "Mobile Data"
            }
            else if iswiredEthernet {
                conTypeLabel.text = "Wired Ethernet"
            }
            else if isloopback {
                conTypeLabel.text = "Loop Back"
            }
            else if isother {
                conTypeLabel.text = "Other"
            }
        }
    }

    func statusDidChange(connectionDetails: NWPath) {
        updateNetworkStateUI(networkPath: connectionDetails)
        let isCellular: Bool = connectionDetails.usesInterfaceType(.cellular)
        print("isCellular: \(isCellular)")
        let isWifi: Bool = connectionDetails.usesInterfaceType(.wifi)
        print("isWifi: \(isWifi)")
        print("----------- ----------- -----------")
    }
    
    
    //MARK:- UIElement Actions
    
    
    //MARK:- Functions
}
