//
//  GroceryMainChildStack.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

/// The main view for displaying and interacting with the grocery list, configured with a data source and delegate.
public struct GroceryMainView: View {
    @StateObject private var composer: GroceriesMainComposer
    
    let onSelection: (GroceryItem) -> ()
    
    /// Initializes a new instance of `GroceryMainView`.
    /// - Parameters:
    ///   - datasource: The data source providing user and category data for the grocery list.
    ///   - delegate: The delegate responsible for handling grocery item actions.
    ///   - onSelection: A closure to execute when a grocery item is selected.
    public init(datasource: GroceryDataSource, delegate: GroceryListDelegate, onSelection: @escaping (GroceryItem) -> Void) {
        self.onSelection = onSelection
        self._composer = .init(wrappedValue: .init(datasource: datasource, delegate: delegate))
    }
    
    public var body: some View {
        GroceryListView(viewModel: composer.makeListViewModel(onSelection: onSelection))
    }
}


// MARK: - Preview
#Preview {
    NavStack(title: "Groceries") {
        GroceryMainView(datasource: .previewInit(), delegate: PreviewGroceryListDelegate(), onSelection: { _ in })
    }
}
