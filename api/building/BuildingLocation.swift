//
//  BuildingLocation.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import _MapKit_SwiftUI

extension Building {
    struct Location: Decodable {
        var lat: Double
        var lon: Double
    }
}

extension Building.Location {
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: self.lat, longitude: self.lon)
    }
    
    var span: MKCoordinateSpan {
        .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
    
    var mapItem: MKMapItem {
        .init(placemark: .init(coordinate: coordinate))
    }
    
    var cameraPosition: MapCameraPosition {
        .region(.init(center: coordinate, span: span))
    }
}
