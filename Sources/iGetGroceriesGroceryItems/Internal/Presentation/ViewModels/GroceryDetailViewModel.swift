//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

final class GroceryDetailViewModel: ObservableObject {
    @Published var allGroceryItems: [GroceryItem]
    
    init() {
        // TODO: -
        self.allGroceryItems = []
    }
}


// MARK: - DisplayData
extension GroceryDetailViewModel {
    var isNewItem: Bool {
        return false
    }
    
    var showResetButton: Bool {
        return !isNewItem
    }
    
    var existingItems: [GroceryItem] {
        return []
    }
}


// MARK: - Actions
extension GroceryDetailViewModel {
    func selectItem(_ item: GroceryItem) {
        
    }
    
    func resetItem() {
        
    }
}
