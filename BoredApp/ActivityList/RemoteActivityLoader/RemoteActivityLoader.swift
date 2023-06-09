//
//  RemoteActivityLoader.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

final class RemoteActivityLoader {
    
    enum RemoteLoaderError: Error {
        case serverError
        case connectionError
    }
    
    func fetch() async throws -> ActivityCodable {
        let url = URL(string: "http://www.boredapi.com/api/activity/")!
        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RemoteLoaderError.serverError
        }
        return try decode(data)
    }
    
    func decode(_ data: Data?) throws -> ActivityCodable {
        do {
            guard let data = data else { throw RemoteLoaderError.serverError }
            return try JSONDecoder().decode(ActivityCodable.self, from: data)
        } catch let error {
            print(error)
        }
        
        throw RemoteLoaderError.serverError
    }
}

struct ActivityCodable: Codable {
    
    let activity: String
    let accessibility: Double
    let type: String
    let participants: Int
    let price: Double
    let key: String
    let link: String?
}
