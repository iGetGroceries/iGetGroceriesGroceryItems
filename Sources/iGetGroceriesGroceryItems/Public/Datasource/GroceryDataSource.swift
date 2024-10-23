//
//  GroceryDataSource.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

public final class GroceryDataSource: ObservableObject {
    @Published public var user: GroceryUser
    @Published public var categories: [GroceryItemCategory]
    
    let showingAllGroceries: Bool
    
    public init(user: GroceryUser, categories: [GroceryItemCategory] = [], showingAllGroceries: Bool) {
        self.user = user
        self.categories = categories
        self.showingAllGroceries = showingAllGroceries
    }
}


// MARK: - Dependencies
public struct GroceryUser {
    public var isGuest: Bool
    public var canAddNewItems: Bool
    
    public init(isGuest: Bool, canAddNewItems: Bool) {
        self.isGuest = isGuest
        self.canAddNewItems = canAddNewItems
    }
}
