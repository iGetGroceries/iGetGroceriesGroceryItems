//
//  GroceriesMainComposer.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

/// A composer class for managing dependencies and creating instances of `GroceryListViewModel`.
final class GroceriesMainComposer: ObservableObject {
    /// The data source providing user and category data for the grocery list.
    private let datasource: GroceryDataSource
    
    /// The delegate responsible for handling grocery item saving and deletion.
    private let delegate: GroceryListDelegate
    
    /// Initializes a new instance of `GroceriesMainComposer`.
    /// - Parameters:
    ///   - datasource: The `GroceryDataSource` to be used for data management.
    ///   - delegate: The `GroceryListDelegate` to handle grocery item actions.
    init(datasource: GroceryDataSource, delegate: GroceryListDelegate) {
        self.datasource = datasource
        self.delegate = delegate
    }
}


// MARK: - Composer
extension GroceriesMainComposer {
    /// Creates and returns a new instance of `GroceryListViewModel` configured with the provided selection handler.
    /// - Parameter onSelection: A closure to execute when a grocery item is selected.
    /// - Returns: A configured `GroceryListViewModel` instance.
    func makeListViewModel(onSelection: @escaping (GroceryItem) -> Void) -> GroceryListViewModel {
        return .init(datasource: datasource, delegate: delegate, onSelection: onSelection)
    }
}
