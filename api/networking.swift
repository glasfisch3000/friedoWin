//
//  networking.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 03.04.24.
//

import Foundation
import Vapor

fileprivate let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return decoder
}()

extension FriedoWin.Server {
    func makeURLPrefix() -> String {
        self.constructed + "/"
    }
}

extension FriedoWin.Server {
    func sendRequest(_ path: String, method: HTTPMethod = .GET, headers: [String: String] = [:]) async throws -> HTTPClient.Response {
        try await sendRequest(path, method: method, query: String?.none, headers: headers)
    }
    
    func sendRequest<Query>(_ path: String, method: HTTPMethod = .GET, query: Query?, headers: [String: String] = [:]) async throws -> HTTPClient.Response where Query: Encodable {
        var url = self.makeURLPrefix() + path
        if let query = query {
            url += "?"
            url += try URLEncodedFormEncoder().encode(query)
        }
        
        var request = try HTTPClient.Request(url: url, method: method)
        for header in headers {
            request.headers.add(name: header.key, value: header.value)
        }
        
        let client = HTTPClient()
        do {
            let result = try await client.execute(request: request).get()
            try? await client.shutdown()
            return result
        } catch {
            try? await client.shutdown()
            throw error
        }
    }
}

extension FriedoWin.Server {
    func sendAPIRequest(_ path: String, method: HTTPMethod = .GET, headers: [String: String] = [:]) async throws -> HTTPClient.Response {
        try await sendAPIRequest(path, method: method, query: String?.none, headers: headers)
    }
    
    func sendAPIRequest<Query>(_ path: String, method: HTTPMethod = .GET, query: Query?, headers: [String: String] = [:]) async throws -> HTTPClient.Response where Query: Encodable {
        var url = self.makeURLPrefix() + "api/" + path
        if let query = query {
            url += "?"
            url += try URLEncodedFormEncoder().encode(query)
        }
        
        var request = try HTTPClient.Request(url: url, method: method)
        for header in headers {
            request.headers.add(name: header.key, value: header.value)
        }
        
        let client = HTTPClient()
        do {
            let result = try await client.execute(request: request).get()
            try? await client.shutdown()
            return result
        } catch {
            try? await client.shutdown()
            throw error
        }
    }
}

extension FriedoWin.Server {
    enum RequestError: Error, Hashable {
        case missingBody
        case unauthorized
        case friedoLinDown
        case httpError(status: HTTPStatus)
    }
    
    func sendRequest<Result>(_ path: String, as type: Result.Type, method: HTTPMethod = .GET, headers: [String: String] = [:]) async throws -> Result where Result: Decodable {
        try await sendRequest(path, as: type, method: method, query: String?.none, headers: headers)
    }
    
    func sendRequest<Query, Result>(_ path: String, as type: Result.Type, method: HTTPMethod = .GET, query: Query?, headers: [String: String] = [:]) async throws -> Result where Query: Encodable, Result: Decodable {
        let response = try await self.sendRequest(path, method: method, query: query, headers: headers)
        
        if response.status == .unauthorized, 
            let body = response.body,
            let errorMessage = body.getString(at: body.readerIndex, length: body.readableBytes), errorMessage == "loggedOut" {
            throw RequestError.unauthorized
        }
        
        if response.status == .badGateway,
            let body = response.body,
            let errorMessage = body.getString(at: body.readerIndex, length: body.readableBytes), errorMessage == "unavailable" {
            throw RequestError.friedoLinDown
        }
        
        guard response.status.mayHaveResponseBody else { throw RequestError.httpError(status: response.status) }
        
        guard let body = response.body else { throw RequestError.missingBody }
        return try jsonDecoder.decode(type, from: body)
    }
}

extension FriedoWin.Server {
    func sendAPIRequest<Result>(_ path: String, as type: Result.Type, method: HTTPMethod = .GET, headers: [String: String] = [:]) async throws -> Result where Result: Decodable {
        try await sendAPIRequest(path, as: type, method: method, query: String?.none, headers: headers)
    }
    
    func sendAPIRequest<Query, Result>(_ path: String, as type: Result.Type, method: HTTPMethod = .GET, query: Query?, headers: [String: String] = [:]) async throws -> Result where Query: Encodable, Result: Decodable {
        let response = try await self.sendAPIRequest(path, method: method, query: query, headers: headers)
        
        if response.status == .unauthorized,
            let body = response.body,
            let errorMessage = body.getString(at: body.readerIndex, length: body.readableBytes), errorMessage == "loggedOut" {
            throw RequestError.unauthorized
        }
        
        if response.status == .badGateway,
            let body = response.body,
            let errorMessage = body.getString(at: body.readerIndex, length: body.readableBytes), errorMessage == "unavailable" {
            throw RequestError.friedoLinDown
        }
        
        guard response.status.mayHaveResponseBody else { throw RequestError.httpError(status: response.status) }
        
        guard let body = response.body else { throw RequestError.missingBody }
        return try jsonDecoder.decode(type, from: body)
    }
}

extension FriedoWin {
    struct AuthenticationResult: Hashable, Codable {
        var session: String
    }
    
    static func authenticate(_ auth: FriedoWin.Credentials, with servers: [FriedoWin.Server]) async throws -> FriedoWin {
        if servers.isEmpty { throw MultiServerRequestError.noServers }
        
        for server in servers {
            do {
                let authentication = try await server.sendAPIRequest("login", as: AuthenticationResult.self, method: .POST, query: auth)
                return .init(servers: servers, token: authentication.session)
            } catch let error as Server.RequestError where error == .friedoLinDown {
                print("friedoLin down")
                throw error
            } catch {
                print(error)
                continue
            }
        }
        
        throw MultiServerRequestError.noResult
    }
}

extension FriedoWin {
    enum MultiServerRequestError: Error {
        case noServers
        case noResult
    }
    
    func sendRequest(_ path: String, method: HTTPMethod = .GET) async throws -> HTTPClient.Response {
        try await self.sendRequest(path, method: method, query: String?.none)
    }
    
    func sendRequest<Query>(_ path: String, method: HTTPMethod = .GET, query: Query?) async throws -> HTTPClient.Response where Query: Encodable {
        if servers.isEmpty { throw MultiServerRequestError.noServers }
        
        for server in self.servers {
            do {
                return try await server.sendAPIRequest(path, method: method, query: query, headers: ["Authorization": "Bearer \(self.token)"])
            } catch {
                print(error)
                continue
            }
        }
        
        throw MultiServerRequestError.noResult
    }
}

extension FriedoWin {
    func sendRequest<Result>(_ path: String, as type: Result.Type, method: HTTPMethod = .GET) async throws -> Result where Result: Decodable {
        try await sendRequest(path, as: type, method: method, query: String?.none)
    }
    
    func sendRequest<Query, Result>(_ path: String, as type: Result.Type, method: HTTPMethod = .GET, query: Query?) async throws -> Result where Query: Encodable, Result: Decodable {
        if servers.isEmpty { throw MultiServerRequestError.noServers }
        
        for server in self.servers {
            do {
                return try await server.sendAPIRequest(path, as: type, method: method, query: query, headers: ["Authorization": "Bearer \(self.token)"])
            } catch let error as Server.RequestError where error == .friedoLinDown {
                print("friedoLin down")
                throw error
            } catch let error as Server.RequestError where error == .unauthorized {
                print("unauthorized")
                throw error
            } catch {
                print(error)
                continue
            }
        }
        
        throw MultiServerRequestError.noResult
    }
}
