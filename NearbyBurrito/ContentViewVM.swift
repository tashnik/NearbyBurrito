//
//  ContentViewVM.swift
//  NearbyBurrito
//
//  Created by David Potashnik on 1/10/24.
//

import Foundation
import Observation
import MapKit


@available(iOS 17.0, *)
@Observable final class ContentViewVM: NSObject, CLLocationManagerDelegate {
    
    let networkManager: NetworkManager
    
    var endpoint = ""
    var places: PlacesTextSearchResponse
    var locationManager: CLLocationManager?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.places = PlacesTextSearchResponse(html_attributions: [], next_page_token: nil, results: [], status: "")
    }
    
    
    func checkIfLocationServicesEnabled() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        } else {
            print("Turn on location services")
        }
    }
    
    
    private func checkLocationAuthorization() {
        
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("location restricted")
        case .denied:
            print("location permission denied")
        case .authorizedAlways, .authorizedWhenInUse:   
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func fetchAllData() async {
        
        checkIfLocationServicesEnabled()
        
        let userLat = String(format: "%f", (locationManager!.location!.coordinate.latitude))
        let userLong = String(format: "%f", (locationManager!.location!.coordinate.longitude))
        
        endpoint = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=burrito&location=\(userLat)%2C\(userLong)&radius=1500&type=restaurant&key=\(NetworkManager.API_KEY)"
        
        do {
            guard let endpoint = URL(string: endpoint) else  {
                throw NBError.invalidURL
            }
            
            self.places = try await networkManager.fetchData(for: PlacesTextSearchResponse.self, from: endpoint)
            
        } catch NBError.invalidURL {
            print("Invalid URL")
            
        } catch NBError.invalidResponse {
            print("Invalid response")
            
        } catch NBError.invalidData {
            print("Invalid data")
            
        } catch {
            print("Unexpected error")
        }
        
    }
}
