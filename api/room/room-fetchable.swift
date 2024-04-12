//
//  room-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

extension FriedoWin {
    func room(_ roomID: Room.ID) -> APIFetchable<Room> {
        APIFetchable(source: self) { api in
            do {
                return try await api.sendRequest("room/\(roomID)", as: Room.self)
            } catch let error as FriedoWin.Server.RequestError where error == .unauthorized {
                api.reauthenticate?()
                throw error
            } catch let error as FriedoWin.Server.RequestError where error == .friedoLinDown {
                api.friedoLinDown?()
                throw error
            } catch {
                print("error while fetching room \(roomID): \(error)")
                throw error
            }
        }
    }
}
