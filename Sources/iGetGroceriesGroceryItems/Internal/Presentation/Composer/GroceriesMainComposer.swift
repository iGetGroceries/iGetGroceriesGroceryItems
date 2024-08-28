//
//  GroceriesMainComposer.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

final class GroceriesMainComposer: ObservableObject {
    private let datasource: GroceryDataSource
    private let delegate: GroceryListDelegate
    
    init(datasource: GroceryDataSource, delegate: GroceryListDelegate) {
        self.datasource = datasource
        self.delegate = delegate
    }
}


// MARK: - Composer
extension GroceriesMainComposer {
    func makeListViewModel(onSelection: @escaping (GroceryItem) -> Void) -> GroceryListViewModel {
        return .init(datasource: datasource, delegate: delegate, onSelection: onSelection)
    }
}
