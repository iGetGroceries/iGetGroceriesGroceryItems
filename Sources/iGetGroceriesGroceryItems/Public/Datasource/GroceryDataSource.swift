//
//  GroceryDataSource.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

public final class GroceryDataSource: ObservableObject {
    @Published public var categories: [GroceryItemCategory]
    
    public init(categories: [GroceryItemCategory] = []) {
        self.categories = categories
    }
}
