//
//  GroceryDataSource.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

/// A data source for managing user information and grocery item categories in the grocery list app.
public final class GroceryDataSource: ObservableObject {
    /// The user information, including permissions for adding new items.
    @Published public var user: GroceryUser
    
    /// The list of grocery item categories.
    @Published public var categories: [GroceryItemCategory]
    
    /// A Boolean indicating whether all grocery items, including purchased ones, should be shown.
    let showingAllGroceries: Bool
    
    /// Initializes a new instance of `GroceryDataSource`.
    /// - Parameters:
    ///   - user: The `GroceryUser` representing the current user.
    ///   - categories: An array of `GroceryItemCategory` instances. Default is an empty array.
    ///   - showingAllGroceries: A Boolean indicating whether all grocery items should be shown.
    public init(user: GroceryUser, categories: [GroceryItemCategory] = [], showingAllGroceries: Bool) {
        self.user = user
        self.categories = categories
        self.showingAllGroceries = showingAllGroceries
    }
}


// MARK: - Dependencies
/// A struct representing the user in the grocery list app, including guest status and permissions.
public struct GroceryUser {
    /// A Boolean indicating if the user is a guest.
    public var isGuest: Bool
    
    /// A Boolean indicating if the user has permission to add new grocery items.
    public var canAddNewItems: Bool
    
    /// Initializes a new `GroceryUser` instance.
    /// - Parameters:
    ///   - isGuest: A Boolean indicating if the user is a guest.
    ///   - canAddNewItems: A Boolean indicating if the user can add new grocery items.
    public init(isGuest: Bool, canAddNewItems: Bool) {
        self.isGuest = isGuest
        self.canAddNewItems = canAddNewItems
    }
}
