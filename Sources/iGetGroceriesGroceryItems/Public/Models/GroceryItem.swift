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
    public var markets: [GroceryMarket]
    public var categoryId: String
    public var oneTimePurchase: Bool
    
    public init(id: String, name: String, purchased: Bool, markets: [GroceryMarket], categoryId: String, oneTimePurchase: Bool) {
        self.id = id
        self.name = name
        self.purchased = purchased
        self.markets = markets
        self.categoryId = categoryId
        self.oneTimePurchase = oneTimePurchase
    }
}


// MARK: - Helper
public extension GroceryItem {
    func togglePurchased() -> GroceryItem {
        var updated = self
        updated.purchased.toggle()
        return updated
    }
}

public struct GroceryMarket: Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
