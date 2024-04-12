//
//  building-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

extension FriedoWin {
    func building(_ buildingID: Building.ID) -> APIFetchable<Building> {
        APIFetchable(source: self) { api in
            do {
                return try await api.sendRequest("building/\(buildingID)", as: Building.self)
            } catch let error as FriedoWin.Server.RequestError where error == .unauthorized {
                api.reauthenticate?()
                throw error
            } catch let error as FriedoWin.Server.RequestError where error == .friedoLinDown {
                api.friedoLinDown?()
                throw error
            } catch {
                print("error while fetching building \(buildingID): \(error)")
                throw error
            }
        }
    }
}
