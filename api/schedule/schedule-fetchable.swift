//
//  schedule-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

extension FriedoWin {
    var schedule: Fetchable<Schedule> {
        Fetchable(api: self) { api in
            do {
                let events = try await api.sendRequest("schedule", as: [Event.ScheduleEvent].self)
                
                var schedule: Schedule = []
                for event in events {
                    let additional = try await api.sendRequest("event/\(event.id)", as: Event.ScheduleEvent.AdditionalInformation.self)
                    schedule.append(event.construct(with: additional))
                }
                
                return schedule
            } catch let error as FriedoWin.Server.RequestError where error == .unauthorized {
                api.reauthenticate?()
                throw error
            } catch {
                print("error while fetching schedule: \(error)")
                throw error
            }
        }
    }
}
