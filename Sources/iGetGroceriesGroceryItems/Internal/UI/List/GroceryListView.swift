//
//  GroceryListView.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

struct GroceryListView: View {
    @FocusState private var isSearching: Bool
    @State private var showingAddButton = true
    @StateObject var viewModel: GroceryListViewModel
    
    var body: some View {
        VStack {
            GroceryListFilterControl(selectedFilter: $viewModel.filter)
                .onlyShow(when: !isSearching && !viewModel.noDisplayableGroceries)
            
            SearchBarView(
                "Search groceries...",
                searchText: $viewModel.searchText,
                isSearching: _isSearching
            )
            .padding(.vertical)
            .frame(width: getWidthPercent(90))
            
            VStack {
                UndoLastPurchaseButton(action: viewModel.undoLastPurchase)
                    .onlyShow(when: viewModel.hasPurchasedItems)
                
                GroceryItemList(viewModel: viewModel)
                    .handlingVerticalPanGesture {
                        showingAddButton = $0 == .down
                    }
            }
            .withEmptyListView(listEmpty: viewModel.noDisplayableGroceries, listType: .groceries(viewModel.searchText))
            .withCircleAddButton(isShowing: $showingAddButton, action: viewModel.addNewItem)
            .animation(.default, value: showingAddButton)
        }
        .mainBackground()
        .animation(.bouncy, value: viewModel.categories)
    }
}


// MARK: - List
fileprivate struct GroceryItemList: View {
    @ObservedObject var viewModel: GroceryListViewModel
    
    var body: some View {
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
            .withErrorHandling()
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

