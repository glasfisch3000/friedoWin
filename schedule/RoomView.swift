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
            case .value(let room): ResolvedView(room, api: $room) { await _room.loadValue() }
            }
        }
        .navigationTitle("Room Info")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ScrollView {
            ProgressView()
        }
        .refreshable {
            await _room.loadValue()
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
        .refreshable {
            await _room.loadValue()
        }
    }
}

extension RoomView {
    private struct ResolvedView: View {
        var room: Room
        
        var api: FriedoWin
        var refresh: () async -> ()
        
        init(_ room: Room, api: FriedoWin, refresh: @escaping () async -> Void) {
            self.room = room
            self.api = api
            self.refresh = refresh
            
            _building = api.building(room.building.id)
            images = room.images?.map { roomImageFetchable($0) } ?? []
        }
        
        @APIFetchable private var building: FetchableStatus<Building>
        private var images: [Fetchable<FriedoWin.Server, UIImage>]
        
        var body: some View {
            Form {
                Section {
                    LabeledContent {
                        Text(room.shortName)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(room.name)
                            
                            Group {
                                if room.additionalName != room.name {
                                    Text(room.additionalName)
                                }
                                
                                Text(room.type.description)
                            }
                            .font(.caption)
                        }
                    }
                    
                    if let url = room.friedoLinURL {
                        Link("View on FriedoLin", destination: url)
                    }
                }
                
                switch building {
                case .error:
                    Section {
                        Text("Unable to load building.")
                            .foregroundStyle(.red)
                    }
                case .loading:
                    Section {
                        LabeledContent("Building") { ProgressView() }
                    }
                case .value(let building):
                    buildingView(building)
                }
                
                if !images.isEmpty {
                    Section("Images") {
                        ForEach(images) { fetchable in
                            ImageView(image: fetchable)
                        }
                    }
                }
                
                if let location = building.value?.location {
                    Section("Location") {
                        Button {
                            location.mapItem.openInMaps()
                        } label: {
                            Map.init(initialPosition: location.cameraPosition, interactionModes: [.zoom, .rotate, .pitch]) {
                                Marker(room.building.name, coordinate: location.coordinate)
                                    .tint(.red)
                            }
                            .mapStyle(.standard)
                            .mapControlVisibility(.hidden)
                            .frame(height: 200)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
            }
            .refreshable {
                await refresh()
                
                _building.refresh()
                
                for image in images {
                    image.refresh()
                }
            }
        }
        
        @ViewBuilder private func buildingView(_ building: Building) -> some View {
            Section {
                LabeledContent("Building", value: building.name)
                LabeledContent("Short Name", value: building.shortName)
                
                if building.additionalName != building.name {
                    LabeledContent("Additional Name", value: building.additionalName)
                }
                
                if let rooms = building.rooms, !rooms.isEmpty {
                    NavigationLink {
                        BuildingRoomsView(rooms: rooms)
                    } label: {
                        Text("Rooms")
                            .badge(rooms.count)
                            .badgeProminence(.decreased)
                    }
                }
            }
            
            if let campus = building.campus {
                LabeledContent("Campus", value: campus)
            }
            
            if let academyBuilding = building.academyBuilding {
                LabeledContent("Academy Building", value: academyBuilding)
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
            LabeledContent("Image") { ProgressView() }
        }
        
        @ViewBuilder private func errorView() -> some View {
            Text("Unable to load image.")
                .foregroundStyle(.red)
        }
        
        @ViewBuilder private func valueView(_ image: UIImage) -> some View {
            Image(uiImage: image)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
}
