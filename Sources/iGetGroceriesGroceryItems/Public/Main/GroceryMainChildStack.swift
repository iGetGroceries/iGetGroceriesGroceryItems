//
//  GroceryMainChildStack.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

public struct GroceryMainChildStack<DetailView: View>: View {
    @State private var selectedItem: GroceryItem?
    @StateObject private var composer: GroceriesMainComposer
    
    let detailView: (GroceryItem) -> DetailView
    
    // TODO: - need to add binding
    public init(datasource: GroceryDataSource, @ViewBuilder detailView: @escaping (GroceryItem) -> DetailView) {
        self.detailView = detailView
        self._composer = .init(wrappedValue: .init(datasource: datasource))
    }
    
    public var body: some View {
        GroceryListView(viewModel: composer.makeListViewModel())
            .sheetWithErrorHandling(item: $selectedItem) { item in
                detailView(item)
            }
    }
}


// MARK: - Preview
#Preview {
    NavStack(title: "Groceries") {
        GroceryMainChildStack(datasource: .previewInit()) { item in
            Text("\(item.name) Details")
        }
    }
}
