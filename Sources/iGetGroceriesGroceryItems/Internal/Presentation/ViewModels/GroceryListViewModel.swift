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
    
    private let delegate: GroceryListDelegate
    private let onSelection: (GroceryItem) -> Void
    
    init(datasource: GroceryDataSource, delegate: GroceryListDelegate, onSelection: @escaping (GroceryItem) -> Void) {
        self.delegate = delegate
        self.categories = datasource.categories
        self.onSelection = onSelection
        
        self.startObservers(datasource)
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
        onSelection(item)
    }
    
    func togglePurchased(_ item: GroceryItem) async throws {
        let updatedItem = item.togglePurchased()
        
        try await delegate.saveItem(updatedItem)
        await addItemToPurchasedGroceriesIfPurchased(updatedItem)
    }
    
    func deleteItem(_ item: GroceryItem) async throws {
        try await delegate.deleteItem(item)
        await removePurchasedGrocery(item)
    }
    
    func undoLastPurchase() async throws {
        guard let lastPurchasedItem = purchasedGroceries.last else {
            return
        }
        
        try await delegate.saveItem(lastPurchasedItem.togglePurchased())
        await removePurchasedGrocery()
    }
    
    func addNewItem() throws {
        onSelection(.new(id: "", name: searchText, categoryId: .other))
    }
}


// MARK: - Private Methods
private extension GroceryListViewModel {
    func startObservers(_ datasource: GroceryDataSource) {
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


// MARK: - MainActor
@MainActor
private extension GroceryListViewModel {
    func removePurchasedGrocery(_ item: GroceryItem? = nil) {
        if let item, let index = purchasedGroceries.firstIndex(where: { $0.id == item.id }) {
            purchasedGroceries.remove(at: index)
        } else {
            purchasedGroceries.removeLast()
        }
    }
    
    func addItemToPurchasedGroceriesIfPurchased(_ item: GroceryItem) {
        if item.purchased {
            purchasedGroceries.append(item)
        } else {
            if let index = purchasedGroceries.firstIndex(where: { $0.id == item.id }) {
                purchasedGroceries.remove(at: index)
            }
        }
    }
}


// MARK: - Dependencies
public protocol GroceryListDelegate {
    func saveItem(_ item: GroceryItem) async throws
    func deleteItem(_ item: GroceryItem) async throws
}
