//
//  room-image-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 12.04.24.
//

import SwiftUI

func roomImageFetchable(_ imageID: Int) -> Fetchable<FriedoWin.Server, UIImage> {
    let server = FriedoWin.Server(scheme: .https, domain: "friedolin.uni-jena.de")
    
    return Fetchable(source: server) { server in
        do {
            let response = try await server.sendRequest("qisserver/rds?state=medialoader&objectid=\(imageID)&application=lsf")
            
            
            guard response.status == .ok else { throw FriedoWin.Server.RequestError.httpError(status: response.status) }
            guard var body = response.body else { throw FriedoWin.Server.RequestError.missingBody }
            
            guard let data = body.readData(length: body.readableBytes) else { throw RoomImageFetchError.missingData }
            
            guard let uiimage = UIImage(data: data) else { throw RoomImageFetchError.invalidImage }
            return uiimage
        } catch {
            print("error while fetching room image \(imageID): \(error)")
            throw error
        }
    }
}

enum RoomImageFetchError: Error {
    case missingData
    case invalidImage
}
