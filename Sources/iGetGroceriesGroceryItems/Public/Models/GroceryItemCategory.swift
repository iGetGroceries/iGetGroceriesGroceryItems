//
//  GroceryItemCategory.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import iGetGroceriesSharedUI

/// A model representing a grocery item category, including an identifier, name, list of items, and color information.
public struct GroceryItemCategory: Identifiable, Equatable {
    /// The unique identifier for the grocery category.
    public let id: String
    
    /// The name of the grocery category.
    public let name: String
    
    /// The list of grocery items within this category.
    public let items: [GroceryItem]
    
    /// The color information associated with this category.
    public let colorInfo: CategoryColor
    
    /// Initializes a new instance of `GroceryItemCategory`.
    /// - Parameters:
    ///   - id: The unique identifier for the category.
    ///   - name: The name of the category.
    ///   - items: An array of `GroceryItem` instances belonging to this category.
    ///   - colorInfo: The color information associated with the category.
    public init(id: String, name: String, items: [GroceryItem], colorInfo: CategoryColor) {
        self.id = id
        self.name = name
        self.items = items
        self.colorInfo = colorInfo
    }
}
