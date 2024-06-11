//
//  news-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.06.24.
//

typealias News = [NewsEntry]

extension [FriedoWin.Server] {
    var news: Fetchable<Self, News> {
        Fetchable(source: self) { servers in
            if servers.isEmpty { throw FriedoWin.MultiServerRequestError.noServers }
            
            for server in self {
                do {
                    return try await server.sendAPIRequest("news", as: News.self)
                } catch {
                    print(error)
                    continue
                }
            }
            
            throw FriedoWin.MultiServerRequestError.noResult
        }
    }
}
