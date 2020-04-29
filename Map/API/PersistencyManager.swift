//
//  PersistencyManager.swift
//  Map
//
//  Created by Rodrigo Buendia Ramos on 4/29/20.
//  Copyright © 2020 Rodrigo Buendia Ramos. All rights reserved.
//

import Foundation
import CoreLocation

final class PersistencyManager {
    // MARK: Properties
    private var locations = [Location]()
    
    // MARK: - Init
    init() {
        let rome = Location(title: "Rome", location:  CLLocationCoordinate2D(latitude: 41.9004041, longitude: 12.4432921))
        
        let milan = Location(title: "Milan", location: CLLocationCoordinate2D(latitude: 45.4625319, longitude: 9.1574741))
        let turin = Location(title: "Turin", location: CLLocationCoordinate2D(latitude: 45.0705805, longitude: 7.6593106))
        let london = Location(title: "London", location: CLLocationCoordinate2D(latitude: 51.5287718, longitude: -0.2416817))
        let paris = Location(title: "Paris", location: CLLocationCoordinate2D(latitude: 48.8589507, longitude: 2.2770201))
        let amsterdam = Location(title: "Amsterdam", location: CLLocationCoordinate2D(latitude: 52.354775, longitude: 4.7585401))
        let dublin = Location(title: "Dublin", location: CLLocationCoordinate2D(latitude: 53.3244431, longitude: -6.3857869))
        let reykjavik = Location(title: "Reykjavik", location: CLLocationCoordinate2D(latitude: 64.1335484, longitude: -21.9224815))
       locations = [rome, milan, turin, london, paris, amsterdam, dublin, reykjavik]
    }
    
    // MARK: - Handlers
    func getLocations() -> [Location] {
        return locations
    }
    
    func addLocation(_ location: Location) {
        locations.append(location)
    }
}
