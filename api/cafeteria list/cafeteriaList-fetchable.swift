//
//  cafeteriaList-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension [FriedoWin.Server] {
    var cafeterias: Fetchable<Self, CafeteriaList> {
        Fetchable(source: self) { servers in
            do {
                let list = try await servers.fetchCafeteriaList()
                
                var cafeterias: [Cafeteria] = []
                for item in list {
                    let additional = try await servers.fetchCafeteria(item.id)
                    cafeterias.append(item.construct(with: additional))
                }
                
                return cafeterias
            } catch {
                print("error while fetching cafeteria list: \(error)")
                throw error
            }
        }
    }
    
    fileprivate func fetchCafeteriaList() async throws -> [Cafeteria.ListItem] {
        if self.isEmpty { throw FriedoWin.MultiServerRequestError.noServers }
        
        for server in self {
            do {
                return try await server.sendRequest("cafeterias", as: [Cafeteria.ListItem].self)
            } catch {
                print(error)
                continue
            }
        }
        
        throw FriedoWin.MultiServerRequestError.noResult
    }
    
    fileprivate func fetchCafeteria(_ id: Cafeteria.ID) async throws -> Cafeteria.ListItem.AdditionalInformation {
        if self.isEmpty { throw FriedoWin.MultiServerRequestError.noServers }
        
        for server in self {
            do {
                return try await server.sendRequest("cafeteria/\(id)", as: Cafeteria.ListItem.AdditionalInformation.self)
            } catch {
                print(error)
                continue
            }
        }
        
        throw FriedoWin.MultiServerRequestError.noResult
    }
}
