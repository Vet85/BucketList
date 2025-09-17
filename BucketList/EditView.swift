//
//  EditView.swift
//  BucketList
//
//  Created by Vitaliy Novichenko on 24.08.2025.
//

import SwiftUI

struct EditView: View {
    
    @State private var viewModel: ViewModel
   
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                        
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(":   ") +
                            Text(page.description)
                                .italic()
                            }
                        
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place detail")
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlace()
            }
        }
    }
  }

#Preview {
    EditView(location: .example) { _ in }
}
