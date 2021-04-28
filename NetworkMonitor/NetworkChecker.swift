//
//  NetworkChecker.swift
//  NetworkMonitor
//
//  Created by Awais Akram on 28.4.2021.
//

import Foundation
import Network

protocol NetworkCheckObserver: class {
    func statusDidChange(connectionDetails: NWPath)
}

class NetworkChecker {
    
    struct NetworkChangeObservation {
        weak var observer: NetworkCheckObserver?
    }
    
    private var monitor = NWPathMonitor()
    private static let _sharedInstance = NetworkChecker()
    private var observations = [ObjectIdentifier: NetworkChangeObservation]()
    
    var currentConnectionDetails: NWPath {
        get {
            return monitor.currentPath
        }
    }
    
    class func sharedInstance() -> NetworkChecker {
        return _sharedInstance
    }
    
    init() {
        monitor.pathUpdateHandler = { [unowned self] path in
            for (id, observations) in self.observations {
                
                //If any observer is nil, remove it from the list of observers
                guard let observer = observations.observer else {
                    self.observations.removeValue(forKey: id)
                    continue
                }
                
                DispatchQueue.main.async(execute: {
                    observer.statusDidChange(connectionDetails: path)
                })
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    func addObserver(observer: NetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = NetworkChangeObservation(observer: observer)
    }
    
    func removeObserver(observer: NetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
    
}
