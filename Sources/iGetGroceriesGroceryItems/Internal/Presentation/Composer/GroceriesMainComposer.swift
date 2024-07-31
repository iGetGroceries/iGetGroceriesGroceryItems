//
//  GroceriesMainComposer.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import Foundation

final class GroceriesMainComposer: ObservableObject {
    private let datasource: GroceryDataSource
    
    init(datasource: GroceryDataSource) {
        self.datasource = datasource
    }
}


// MARK: - Composer
extension GroceriesMainComposer {
    func makeListViewModel() -> GroceryListViewModel {
        return .init(datasource: datasource)
    }
}
