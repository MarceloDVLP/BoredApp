//
//  RemoteActivityLoader.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

enum RemoteLoaderError: Error {
    case serverError
    case connectionError
}

final class RemoteActivityLoader {
    
    private var clientHTTP: ClientHTTP
    
    init(clientHTTP: ClientHTTP) {
        self.clientHTTP = clientHTTP
    }
    
    func fetch(_ filter: [String] = []) async throws -> ActivityCodable {
        var urlComponents = URLComponents(string: "http://www.boredapi.com/api/activity/")!
        if filter.count > 0 {
            urlComponents.queryItems = [URLQueryItem(name: "type", value: filter[0])]
        }
        let data = try await clientHTTP.fetch(urlComponents.url!)
        return try decode(data)
    }
    
    func decode(_ data: Data) throws -> ActivityCodable {
        do {
            return try JSONDecoder().decode(ActivityCodable.self, from: data)
        } catch let error {
            print(error)
        }
        throw RemoteLoaderError.serverError
    }
}