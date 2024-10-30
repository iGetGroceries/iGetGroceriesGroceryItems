//
//  GroceryListViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

/// A view model for managing the grocery list, including filtering, displaying, and handling actions related to grocery items.
final class GroceryListViewModel: ObservableObject {
    /// The search text input by the user for filtering grocery items by name.
    @Published var searchText = ""
    
    /// The current filter option selected by the user to show or hide purchased items.
    @Published var filter: GroceryListFilterOption = .showAll
    
    /// The list of grocery item categories, each containing a list of grocery items.
    @Published var categories: [GroceryItemCategory]
    
    /// A list of items that have been marked as purchased.
    @Published private var purchasedGroceries: [GroceryItem]
    
    /// A complete list of all groceries, without filtering, for internal use.
    @Published private(set) var allGroceries: [GroceryItem] = []
    
    private let delegate: GroceryListDelegate
    private let datasource: GroceryDataSource
    private let onSelection: (GroceryItem) -> Void
    
    /// Initializes a new instance of `GroceryListViewModel`.
    /// - Parameters:
    ///   - datasource: The data source providing user and category data.
    ///   - delegate: The delegate responsible for saving and deleting items.
    ///   - purchasedItems: An optional list of pre-existing purchased items.
    ///   - onSelection: A closure to execute when an item is selected for viewing details.
    init(datasource: GroceryDataSource, delegate: GroceryListDelegate,
         purchasedItems: [GroceryItem] = [], onSelection: @escaping (GroceryItem) -> Void) {
        self.delegate = delegate
        self.datasource = datasource
        self.categories = datasource.categories
        self.purchasedGroceries = purchasedItems
        self.onSelection = onSelection
        
        self.startObservers(datasource)
    }
}


// MARK: - DisplayData
extension GroceryListViewModel {
    /// A Boolean indicating whether the view should display the markets associated with grocery items.
    var shouldShowMarkets: Bool {
        return datasource.showingAllGroceries
    }
    
    /// A Boolean indicating if there are any purchased items to display.
    var hasPurchasedItems: Bool {
        return !purchasedGroceries.isEmpty
    }
    
    /// A Boolean indicating whether there are no items to display in any category.
    var noDisplayableGroceries: Bool {
        return categories.flatMap({ $0.items }).isEmpty
    }
}


// MARK: - Actions
extension GroceryListViewModel {
    /// Shows the details for a specific grocery item.
    /// - Parameter item: The grocery item to show details for.
    func showDetails(for item: GroceryItem) {
        onSelection(item)
    }
    
    /// Toggles the purchased state of a grocery item.
    /// - Parameter item: The grocery item to toggle.
    func togglePurchased(_ item: GroceryItem) async throws {
        let updatedItem = item.togglePurchased()
        try await delegate.saveItem(updatedItem)
        await addItemToPurchasedGroceriesIfPurchased(updatedItem)
    }
    
    /// Deletes a grocery item from the list.
    /// - Parameter item: The grocery item to delete.
    func deleteItem(_ item: GroceryItem) async throws {
        try await delegate.deleteItem(item)
        await removePurchasedGrocery(item)
    }
    
    /// Undoes the last purchase by toggling the purchased state of the last purchased item.
    func undoLastPurchase() async throws {
        guard let lastPurchasedItem = purchasedGroceries.last else {
            return
        }
        try await delegate.saveItem(lastPurchasedItem.togglePurchased())
        await removePurchasedGrocery()
    }
    
    /// Adds a new grocery item based on the current search text.
    /// Throws an error if the user is not allowed to add new items.
    func addNewItem() throws {
        guard datasource.user.canAddNewItems else {
            throw datasource.user.isGuest ? GroceryListError.guestItemLimitReached : GroceryListError.itemLimitReached
        }
        onSelection(.new(id: "", name: searchText, categoryId: .other))
    }
}


// MARK: - Private Methods
private extension GroceryListViewModel {
    /// Starts observing changes in categories and updates the filtered categories and all groceries accordingly.
    /// - Parameter datasource: The data source containing the category data to observe.
    func startObservers(_ datasource: GroceryDataSource) {
        datasource.$categories
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { categories in
                return categories.flatMap({ $0.items })
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$allGroceries)
        
        datasource.$categories
            .combineLatest($searchText, $filter)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { categories, searchText, filter in
                return categories.compactMap { category in
                    let filteredItems = category.items.filter { item in
                        if searchText.isEmpty {
                            return filter == .showAll ? true : !item.purchased
                        }
                        return item.name.localizedCaseInsensitiveContains(searchText)
                    }
                    return filteredItems.isEmpty ? nil : .init(id: category.id, name: category.name, items: filteredItems, colorInfo: category.colorInfo)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$categories)
    }
}


// MARK: - MainActor
@MainActor
private extension GroceryListViewModel {
    /// Removes a grocery item from the purchased list.
    /// - Parameter item: The grocery item to remove. If `nil`, the last item is removed.
    func removePurchasedGrocery(_ item: GroceryItem? = nil) {
        if let item {
            if let index = purchasedGroceries.firstIndex(where: { $0.id == item.id }) {
                purchasedGroceries.remove(at: index)
            }
        } else {
            purchasedGroceries.removeLast()
        }
    }
    
    /// Adds a grocery item to the purchased list if it has been marked as purchased, or removes it if unpurchased.
    /// - Parameter item: The grocery item to add or remove based on its purchase state.
    func addItemToPurchasedGroceriesIfPurchased(_ item: GroceryItem) {
        if item.purchased {
            purchasedGroceries.append(item)
        } else if let index = purchasedGroceries.firstIndex(where: { $0.id == item.id }) {
            purchasedGroceries.remove(at: index)
        }
    }
}


// MARK: - Dependencies
/// Protocol defining delegate methods for saving and deleting grocery items.
public protocol GroceryListDelegate {
    func saveItem(_ item: GroceryItem) async throws
    func deleteItem(_ item: GroceryItem) async throws
}
