//
//  ContentView.swift
//  BucketList
//
//  Created by Vitaliy Novichenko on 17.08.2025.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
   )
    @State private var viewModel = ViewModel()
   
    var body: some View {
        NavigationStack {
            if viewModel.isUnlocked {
                ZStack {
                    MapReader { proxy in
                        Map(initialPosition: startPosition) {
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                    //                            .onLongPressGesture {
                                    //                                selectedPlace = location
                                    //                            }
                                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                                            .onEnded{ _ in
                                                viewModel.selectedPlace = location
                                            }
                                        )
                                    
                                }
                                
                            }
                        }
                        
//                        .mapStyle(viewModel.mapStyle == .standard ? .standard : .hybrid)
                        .mapStyle(viewModel.mapStyle == .standard ? .standard : .hybrid)
                        .onTapGesture { position in // показывает всего лишь координаты экрана
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                                
                            }
                        }
                        
                        .sheet(item: $viewModel.selectedPlace) { place in
                            EditView(location: place) {
                                viewModel.update(location: $0)
                            }
                        }
                        
                    }
                }
                . toolbar {
                    Menu("Map Mode", systemImage: "globe") {
                        Picker("Map Style", selection: $viewModel.mapStyle) {
                            Text("Standart Map")
                                .tag(ViewModel.MapStyle.standard)
                            Text("Hybrid Map")
                                .tag(ViewModel.MapStyle.hybrid)
                        }
                    }
                    Button("OK Ok Ok") { }
                }
                
            }else {
                Button("Unlock Place", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                    .alert("Ошибка аутентификации", isPresented: $viewModel.isShowingAuthenticateError) {
                        Button("OK", role: .cancel) {  }
                    }
            }
                
        }
        
    }
}

#Preview {
    ContentView()
}
