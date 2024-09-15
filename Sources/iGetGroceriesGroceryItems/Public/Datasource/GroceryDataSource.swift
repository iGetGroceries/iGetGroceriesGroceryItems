//
//  GroceryDataSource.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

public final class GroceryDataSource: ObservableObject {
    @Published public var categories: [GroceryItemCategory]
    
    let showingAllGroceries: Bool
    
    public init(categories: [GroceryItemCategory] = [], showingAllGroceries: Bool) {
        self.categories = categories
        self.showingAllGroceries = showingAllGroceries
    }
}
