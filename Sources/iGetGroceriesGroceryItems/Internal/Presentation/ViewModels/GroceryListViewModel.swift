//
//  GroceryListViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

final class GroceryListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var filter: GroceryListFilterOption = .showAll
    @Published var categories: [GroceryItemCategory]
    @Published private var purchasedGroceries: [GroceryItem] = []
    
    init(datasource: GroceryDataSource) {
        categories = datasource.categories
        datasource.$categories.assign(to: &$categories)
        datasource.$categories
            .combineLatest($searchText, $filter)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { categories, searchText, filter in
                return categories.map { category in
                    let categoryItems = category.items
                    let filteredItems = categoryItems.filter { item in
                        if searchText.isEmpty {
                            return filter == .showAll ? true : !item.purchased
                        }
                        
                        return item.name.localizedCaseInsensitiveContains(searchText)
                    }
                    
                    return .init(id: category.id, name: category.name, items: filteredItems, colorInfo: category.colorInfo)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$categories)
    }
}


// MARK: - DisplayData
extension GroceryListViewModel {
    var hasPurchasedItems: Bool {
        return !purchasedGroceries.isEmpty
    }
    
    var noDisplayableGroceries: Bool {
        return categories.flatMap({ $0.items }).isEmpty
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
    
    func undoLastPurchase() async throws {
        // TODO: - 
    }
}
