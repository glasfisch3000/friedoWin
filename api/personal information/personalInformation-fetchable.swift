//
//  personalInformation-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

extension FriedoWin {
    var personalInformation: APIFetchable<PersonalInformation> {
        APIFetchable(source: self) { api in
            do {
                return try await api.sendRequest("myInfo", as: PersonalInformation.self)
            } catch let error as FriedoWin.Server.RequestError where error == .unauthorized {
                api.reauthenticate?()
                throw error
            } catch let error as FriedoWin.Server.RequestError where error == .friedoLinDown {
                api.friedoLinDown?()
                throw error
            } catch {
                print("error while fetching personalInformation: \(error)")
                throw error
            }
        }
    }
}
