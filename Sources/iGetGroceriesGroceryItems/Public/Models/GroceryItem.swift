//
//  GroceryItem.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

public struct GroceryItem: Identifiable, Hashable {
    public var id: String
    public var name: String
    public var purchased: Bool
    public var marketIds: [String]
    public var categoryId: String
    public var oneTimePurchase: Bool
    
    public init(id: String, name: String, purchased: Bool, marketIds: [String], categoryId: String, oneTimePurchase: Bool) {
        self.id = id
        self.name = name
        self.purchased = purchased
        self.marketIds = marketIds
        self.categoryId = categoryId
        self.oneTimePurchase = oneTimePurchase
    }
}
