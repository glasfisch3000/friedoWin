//
//  module-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension FriedoWin {
    func module(_ moduleID: Module.ID) -> Fetchable<Module> {
        Fetchable(api: self) { api in
            do {
                return try await api.sendRequest("module/\(moduleID)", as: Module.self)
            } catch let error as FriedoWin.Server.RequestError where error == .unauthorized {
                api.reauthenticate?()
                throw error
            } catch {
                print("error while fetching module \(moduleID): \(error)")
                throw error
            }
        }
    }
}
