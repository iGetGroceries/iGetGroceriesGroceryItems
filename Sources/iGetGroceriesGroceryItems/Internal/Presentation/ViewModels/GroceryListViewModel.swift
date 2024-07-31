//
//  GroceryListViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

final class GroceryListViewModel: ObservableObject {
    @Published var categories: [GroceryItemCategory]
    @Published var filter: GroceryListFilterOption = .showAll
    
    init(datasource: GroceryDataSource) {
        categories = datasource.categories
        datasource.$categories.assign(to: &$categories)
    }
}


// MARK: - Actions
extension GroceryListViewModel {
    func showDetails(for item: GroceryItem) {
        // TODO: -
    }
    
    func togglePurchased(_ item: GroceryItem) async throws {
        // TODO: -
    }
    
    func deleteItem(_ item: GroceryItem) async throws {
        // TODO: -
    }
}
