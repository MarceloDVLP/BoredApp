//
//  ClientHTTP.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

final class ClientHTTP {
    
    private var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetch(_ url: URL) async throws -> (Data) {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RemoteLoaderError.serverError
        }
        return data
    }
}
