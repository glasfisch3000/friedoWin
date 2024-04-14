//
//  RoomView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI
import MapKit

struct RoomView: View {
    @APIFetchable var room: FetchableStatus<Room>
    
    var body: some View {
        Group {
            switch room {
            case .error: errorView()
            case .loading: loadingView()
            case .value(let room): valueView(room)
            }
        }
        .refreshable {
            await _room.loadValue()
        }
        .navigationTitle("Room Info")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ScrollView {
            ProgressView()
        }
    }
    
    @ViewBuilder private func errorView() -> some View {
        ScrollView {
            VStack {
                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                    .font(.title)
                
                Text("Unable to load event.")
            }
        }
    }
    
    @ViewBuilder private func valueView(_ room: Room) -> some View {
        Form {
            LabeledContent("Room", value: room.name)
            
            BuildingView(roomBuilding: room.building, building: $room.building(room.building.id))
            
            if let imageID = room.image {
                ImageView(image: roomImageFetchable(imageID))
            }
        }
    }
}

extension RoomView {
    struct BuildingView: View {
        var roomBuilding: Room.Building
        @APIFetchable var building: FetchableStatus<Building>
        
        var body: some View {
            switch building {
            case .error: errorView()
            case .loading: loadingView()
            case .value(let building): valueView(building)
            }
        }
        
        @ViewBuilder private func loadingView() -> some View {
            LabeledContent("Building") {
                ProgressView()
            }
        }
        
        @ViewBuilder private func errorView() -> some View {
            LabeledContent("Building", value: roomBuilding.name)
        }
        
        @ViewBuilder private func valueView(_ building: Building) -> some View {
            Section {
                LabeledContent("Campus", value: building.campus)
                LabeledContent("Building", value: building.academyBuilding)
            }
            
            if let location = building.location {
                Section {
                    Button {
                        location.mapItem.openInMaps()
                    } label: {
                        Map.init(initialPosition: location.cameraPosition) {
                            Marker(roomBuilding.name, coordinate: location.coordinate)
                                .tint(.red)
                        }
                        .mapStyle(.standard)
                        .mapControlVisibility(.hidden)
                        .frame(height: 250)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
    }
}

extension RoomView {
    struct ImageView: View {
        @Fetchable<FriedoWin.Server, UIImage> var image: FetchableStatus<UIImage>
        
        var body: some View {
            switch image {
            case .error: errorView()
            case .loading: loadingView()
            case .value(let image): valueView(image)
            }
        }
        
        @ViewBuilder private func loadingView() -> some View {
            LabeledContent("Image") {
                ProgressView()
            }
        }
        
        @ViewBuilder private func errorView() -> some View {
            Text("Unable to load image.")
                .foregroundStyle(.red)
        }
        
        @ViewBuilder private func valueView(_ image: UIImage) -> some View {
            Section {
                Image(uiImage: image)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}
