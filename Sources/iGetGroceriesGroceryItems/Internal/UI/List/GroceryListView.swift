//
//  GroceryListView.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

struct GroceryListView: View {
    @StateObject var viewModel: GroceryListViewModel
    
    var body: some View {
        VStack {
            GroceryListFilterControl(selectedFilter: $viewModel.filter)
            
            // TODO: - SearchBarView
            
            // TODO: - UndoLastPurchaseButton
            
            List(viewModel.categories) { category in
                Section {
                    ForEach(category.items) { item in
                        GroceryItemRow(item: item) {
                            viewModel.showDetails(for: item)
                        }
                        .padding(.vertical)
                        .asyncTapGesture(asRowItem: .noChevron) {
                            try await viewModel.togglePurchased(item)
                        }
                        .withSwipeDelete("") { // TODO: - add message
                            try await viewModel.deleteItem(item)
                        }
                    }
                    .listRowBackground(Color.secondaryBackground)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                } header: {
                    Text(category.name)
                        .withFont(.caption)
                        .padding(5)
                        .frame(width: getWidthPercent(100), alignment: .leading)
                        .background(category.color)
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: getHeightPercent(2), trailing: 0))
                .onlyShow(when: !category.items.isEmpty)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .mainBackground()
    }
}


// MARK: - Row
fileprivate struct GroceryItemRow: View {
    let item: GroceryItem
    let showDetails: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                    .withFont(autoSizeLineLimit: 2)
                    .opacity(item.purchased ? 0.5 : 1)
                
                Spacer()
                
                Text("Purchased")
                    .withFont(textColor: .red)
                    .onlyShow(when: item.purchased)
                
                Button(action: showDetails) {
                    Image(systemName: "info.circle")
                        .tint(.darkGreen)
                        .padding(.horizontal)
                }
            }
        }
    }
}


// MARK: - Preview
#Preview {
    NavStack(title: "Groceries") {
        GroceryListView(viewModel: .init(datasource: .previewInit()))
    }
}


// MARK: - Extension Dependencies
fileprivate extension GroceryItemCategory {
    var color: Color {
        switch colorInfo {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        }
    }
}
