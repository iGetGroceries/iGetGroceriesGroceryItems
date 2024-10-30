//
//  GroceryListFilterOption.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

/// An enum representing filter options for displaying grocery list items.
enum GroceryListFilterOption: String, CaseIterable {
    /// Option to show all grocery items, including purchased ones.
    case showAll = "Show All"
    
    /// Option to hide purchased grocery items.
    case hidePurchased = "Hide Purchased"
}
