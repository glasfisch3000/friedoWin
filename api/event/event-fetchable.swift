//
//  event-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

extension FriedoWin {
    func event(_ eventID: Event.ID) -> APIFetchable<Event> {
        APIFetchable(source: self) { api in
            do {
                return try await api.sendRequest("event/\(eventID)", as: Event.self)
            } catch let error as FriedoWin.Server.RequestError where error == .unauthorized {
                api.reauthenticate?()
                throw error
            } catch let error as FriedoWin.Server.RequestError where error == .friedoLinDown {
                api.friedoLinDown?()
                throw error
            } catch {
                print("error while fetching event \(eventID): \(error)")
                throw error
            }
        }
    }
}
