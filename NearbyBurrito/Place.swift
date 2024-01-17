//
//  Place.swift
//  NearbyBurrito
//
//  Created by David Potashnik on 1/10/24.
//

import Foundation
import MapKit

struct Restaurant: Identifiable {
    
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


struct PlacesTextSearchResponse: Decodable {
    
    let html_attributions: [String]
    let next_page_token: String?
    let results: [Place]
    let status: String
}


struct Place: Decodable {
    
    let business_status: String?
    let formatted_address: String?
    let geometry: Geometry?
    let icon: String?
    let icon_background_color: String?
    let icon_mask_base_uri: String?
    let name: String?
    let opening_hours: PlaceOpeningHours?
    let photos: [Photo]?
    let place_id: String?
    let plus_code: PlusCode?
    let price_level: Int?
    let rating: Double?
    let reference: String?
    let types: [String]?
    let user_ratings_total: Int?
}

struct PlaceOpeningHours: Decodable {
    
    let open_now: Bool
}

struct Photo: Decodable {
    
    let height: Int
    let html_attributions: [String]
    let photo_reference: String
    let width: Int
}

struct Bounds: Decodable {
    
    let northeast: LatLngLiteral
    let southwest: LatLngLiteral
}

struct Geometry: Decodable {
    
    let location: LatLngLiteral
    let viewport: Bounds
}

struct LatLngLiteral: Decodable {
    
    let lat: Double
    let lng: Double
}

struct PlusCode: Decodable {
    
    let compound_code: String
    let global_code: String
}
