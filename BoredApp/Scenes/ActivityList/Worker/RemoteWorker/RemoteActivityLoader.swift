//
//  RemoteActivityLoader.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

final class RemoteActivityWorker {
    
    private var clientHTTP: ClientHTTP
    
    init(clientHTTP: ClientHTTP) {
        self.clientHTTP = clientHTTP
    }
    
    func fetch(_ actityType: String? = nil) async throws -> Result<ActivityCodable, Error> {
        guard let url = makeURL(actityType) else {
            return .failure(RemoteLoaderError.invalidURL)
        }

        let data = try await clientHTTP.fetch(url)
        return try decode(data)
    }
    
    private func decode(_ data: Data) throws -> Result<ActivityCodable, Error> {
        do {
            let activity = try JSONDecoder().decode(ActivityCodable.self, from: data)
            return .success(activity)
        } catch let error {
            print(error)
            throw RemoteLoaderError.jsonDecode
        }
    }
    
    private func makeURL(_ actityType: String? = nil) -> URL? {
        guard let url = URL(string: BoredAPI.activity.url) else { return nil }
        
        guard let actityType,
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "type", value: actityType)]
        
        guard let url = urlComponents.url else {
            return url
        }
        
        return url
    }
}

enum RemoteLoaderError: Error {
    case invalidURL
    case connectionError
    case serverError
    case jsonDecode
}

enum BoredAPI {

    case activity

    var url: String {
        return "http://www.boredapi.com/api/activity/"
    }
}
