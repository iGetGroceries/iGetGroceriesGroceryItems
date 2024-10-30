//
//  GroceryListError.swift
//
//
//  Created by Nikolai Nobadi on 8/28/24.
//

/// An enumeration of errors that can occur in the grocery list app, related to item limits and user permissions.
public enum GroceryListError: Error {
    /// Error indicating that the item limit has been reached.
    case itemLimitReached
    
    /// Error indicating that the item limit has been reached for a guest user.
    case guestItemLimitReached
}
