//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Vitaliy Novichenko on 16.09.2025.

//_name = State(initialValue: location.name)
//_description = State(initialValue: location.description)

import Foundation
import MapKit
import SwiftUI

extension EditView {
    @Observable
    class ViewModel {
        
        
        enum LoadingState {
            case loading, loaded, failed
        }
        var loadingState = LoadingState.loading
        
        
        var location: Location
        
        var name: String
        var description: String
        var pages = [Page]()
        
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
            
            
        }
        func createNewLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            
            return newLocation
        }
        
        func fetchNearbyPlace() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL \(urlString)")
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                //Эта строка выполняет асинхронный сетевой запрос и получает данные по указанному URL
                let items = try JSONDecoder().decode(Result.self, from: data)
                //Эта строка преобразует сырые JSON-данные в Swift-объекты
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }

        }
    }
}
