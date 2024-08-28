//
//  PreviewContent.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

// MARK: - Category
extension GroceryItemCategory {
    static var sampleList: [GroceryItemCategory] {
        return [
            .init(id: .produce, name: .produce, items: GroceryItem.sampleProduceList, colorInfo: .green),
            .init(id: .meat, name: .meat, items: GroceryItem.sampleMeatList, colorInfo: .red),
            .init(id: .dairy, name: .dairy, items: GroceryItem.sampleDairyList, colorInfo: .blue),
            .init(id: .other, name: .other, items: GroceryItem.sampleOtherList, colorInfo: .yellow)
        ]
    }
}


// MARK: - Item
extension GroceryItem {
    static func new(id: String, name: String, purchased: Bool = false, marketIds: [String] = [], categoryId: String, oneTimePurchase: Bool = false) -> GroceryItem {
        return .init(id: id, name: name, purchased: purchased, marketIds: marketIds, categoryId: categoryId, oneTimePurchase: oneTimePurchase)
    }
    
    static var sampleProduceList: [GroceryItem] {
        return [
            .new(id: "0", name: "Carrots", categoryId: .produce),
            .new(id: "1", name: "Apples", purchased: true, categoryId: .produce)
        ]
    }
    
    static var sampleMeatList: [GroceryItem] {
        return [
            .new(id: "10", name: "Bacon", categoryId: .meat),
            .new(id: "11", name: "Chicken Thighs", categoryId: .meat)
        ]
    }
    
    static var sampleDairyList: [GroceryItem] {
        return [
            .new(id: "100", name: "Milk", purchased: true, categoryId: .dairy),
            .new(id: "101", name: "Cream Cheese", purchased: true, categoryId: .dairy)
        ]
    }
    
    static var sampleOtherList: [GroceryItem] {
        return [
            .new(id: "1000", name: "AC Filter", categoryId: .dairy, oneTimePurchase: true),
        ]
    }
}


// MARK: - Category Names
extension String {
    static var produce: String {
        return "Produce"
    }
    
    static var meat: String {
        return "Meat"
    }
    
    static var dairy: String {
        return "Dairy"
    }
    
    static var other: String {
        return "Other"
    }
}


// MARK: - Datasource
extension GroceryDataSource {
    static func previewInit(categories: [GroceryItemCategory] = GroceryItemCategory.sampleList) -> GroceryDataSource {
        return .init(categories: categories)
    }
}
