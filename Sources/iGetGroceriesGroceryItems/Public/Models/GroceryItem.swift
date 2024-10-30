//
//  GroceryItem.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

/// A model representing a grocery item, with properties for identification, purchase status, markets, category, and purchase type.
public struct GroceryItem: Identifiable, Hashable {
    /// The unique identifier for the grocery item.
    public var id: String
    
    /// The name of the grocery item.
    public var name: String
    
    /// A Boolean indicating if the item has been purchased.
    public var purchased: Bool
    
    /// A list of markets where the item can be found.
    public var markets: [GroceryMarket]
    
    /// The identifier for the category the item belongs to.
    public var categoryId: String
    
    /// A Boolean indicating if the item is a one-time purchase.
    public var oneTimePurchase: Bool
    
    /// Initializes a new instance of `GroceryItem`.
    /// - Parameters:
    ///   - id: The unique identifier for the grocery item.
    ///   - name: The name of the grocery item.
    ///   - purchased: Indicates if the item has been purchased.
    ///   - markets: The list of markets associated with the item.
    ///   - categoryId: The category ID for the item.
    ///   - oneTimePurchase: Indicates if the item is a one-time purchase.
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
    /// Toggles the purchase status of the grocery item and returns an updated instance.
    /// - Returns: A new `GroceryItem` instance with the toggled `purchased` state.
    func togglePurchased() -> GroceryItem {
        var updated = self
        updated.purchased.toggle()
        return updated
    }
}

/// A model representing a grocery market, with properties for identification and name.
public struct GroceryMarket: Hashable {
    /// The unique identifier for the market.
    public let id: String
    
    /// The name of the market.
    public let name: String
    
    /// Initializes a new instance of `GroceryMarket`.
    /// - Parameters:
    ///   - id: The unique identifier for the market.
    ///   - name: The name of the market.
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
