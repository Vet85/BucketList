//
//  Location.swift
//  BucketList
//
//  Created by Vitaliy Novichenko on 22.08.2025.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    #if DEBUG
    static let example = Location(id: UUID(), name: "Red Squer", description: "Главная площадь Москвы", latitude: 55.754167, longitude: 37.620000)
    #endif
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
