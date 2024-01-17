//
//  NetworkManager.swift
//  NearbyBurrito
//
//  Created by David Potashnik on 1/10/24.
//

import Foundation

final class NetworkManager {
 
    static let API_KEY =  "AIzaSyA-6hj2hqkEn-LeqfiAhK_fBoxCsW9GAlw"
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(for: T.Type, from url: URL) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NBError.invalidURL
        }
        
        do {
            let decoder = JSONDecoder()
            
            return try decoder.decode(T.self, from: data)
        } catch {
            print(response.statusCode)
            print("here")
            throw NBError.invalidData
        }
    }
}
