//
//  GroceryMainChildStack.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

public struct GroceryMainView: View {
    @StateObject private var composer: GroceriesMainComposer
    
    let onSelection: (GroceryItem) -> ()
    
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
