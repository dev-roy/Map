//
//  LocationAPI.swift
//  Map
//
//  Created by Rodrigo Buendia Ramos on 4/29/20.
//  Copyright © 2020 Rodrigo Buendia Ramos. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationAPI {
    
    // MARK: - Properties
    static let shared = LocationAPI()
    private let persistencyManager = PersistencyManager()
    
    // MARK: - Handlers
    func getLocations() -> [Location] {
        persistencyManager.getLocations()
    }
}
