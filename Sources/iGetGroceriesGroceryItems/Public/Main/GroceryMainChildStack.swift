//
//  GroceryMainChildStack.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

public struct GroceryMainChildStack: View {
    @StateObject private var composer: GroceriesMainComposer
    
    // TODO: - need to add binding
    public init(datasource: GroceryDataSource) {
        self._composer = .init(wrappedValue: .init(datasource: datasource))
    }
    
    public var body: some View {
        GroceryListView(viewModel: composer.makeListViewModel())
            .navigationDestination(for: GroceryItem.self) { item in
                Text(item.name)
            }
    }
}


// MARK: - Preview
#Preview {
    NavStack(title: "Groceries") {
        GroceryMainChildStack(datasource: .previewInit())
    }
}
