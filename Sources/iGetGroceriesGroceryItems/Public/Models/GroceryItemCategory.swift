//
//  GroceryItemCategory.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import iGetGroceriesSharedUI

public struct GroceryItemCategory: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let items: [GroceryItem]
    public let colorInfo: CategoryColor
    
    public init(id: String, name: String, items: [GroceryItem], colorInfo: CategoryColor) {
        self.id = id
        self.name = name
        self.items = items
        self.colorInfo = colorInfo
    }
}
