//
//  ContentView.swift
//  NearbyBurrito
//
//  Created by David Potashnik on 1/10/24.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct ContentView: View {
    
    var contentViewVM = ContentViewVM(networkManager: .shared)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contentViewVM.places.results, id: \.place_id) { result in
                    
                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (result.geometry?.location.lat)!, longitude: (result.geometry?.location.lng)!), span: MKCoordinateSpan(latitudeDelta: 0.0007, longitudeDelta: 0.0007))
                    
                    let annotations = [Restaurant(name: result.name ?? "name", coordinate: CLLocationCoordinate2D(latitude: (result.geometry?.location.lat)!, longitude: (result.geometry?.location.lng)!))]
                    
                    NavigationLink {
                        Map(coordinateRegion: .constant(region), annotationItems: annotations) {
                            MapMarker(coordinate: $0.coordinate, tint: .purple)
                        }
                        .ignoresSafeArea()
                        
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(result.name ?? "name")")
                                .font(.title)
                                .bold()
                                .foregroundColor(.purple)
                            Text("\(result.formatted_address ?? "address")")
                            HStack(spacing: 5) {
                                ForEach(0...(result.price_level ?? 0), id: \.self) { _ in
                                    Text("$")
                                }
                                Text("\(result.rating?.formatted() ?? "")")
                                Image(systemName: "star.fill")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nearby Burritos")
        }
        .task {
            await contentViewVM.fetchAllData()
        }
    }
}



@available(iOS 17.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
