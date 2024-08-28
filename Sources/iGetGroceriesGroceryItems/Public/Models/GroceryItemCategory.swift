//
//  GroceryItemCategory.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

public struct GroceryItemCategory: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let items: [GroceryItem]
    public let colorInfo: GroceryItemCategoryColorInfo
    
    public init(id: String, name: String, items: [GroceryItem], colorInfo: GroceryItemCategoryColorInfo) {
        self.id = id
        self.name = name
        self.items = items
        self.colorInfo = colorInfo
    }
}


// MARK: - Dependencies
public enum GroceryItemCategoryColorInfo {
    case red, green, blue, yellow
}
