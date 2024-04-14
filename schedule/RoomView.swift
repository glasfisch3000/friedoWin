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
                    LabeledContent("Name", value: "\(room.name) (\(room.building.name))")
                    LabeledContent("Short Name", value: room.shortName)
                    
                    if room.additionalName != room.name {
                        LabeledContent("Additional Name", value: room.additionalName)
                    }
                    
                    LabeledContent("Room Type", value: room.type.description)
                    
                    if let url = room.friedoLinURL {
                        Link("View on FriedoLin", destination: url)
                    }
                }
                
                Section {
                    switch building {
                    case .error:
                        Text("Unable to load building.")
                            .foregroundStyle(.red)
                    case .loading:
                        LabeledContent("Building") { ProgressView() }
                    case .value(let building):
                        buildingView(building)
                    }
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
            LabeledContent("Campus", value: building.campus)
            LabeledContent("Building", value: building.academyBuilding)
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
