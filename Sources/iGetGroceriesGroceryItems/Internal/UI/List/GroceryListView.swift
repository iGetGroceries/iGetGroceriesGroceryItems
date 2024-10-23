//
//  GroceryListView.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI
import iGetGroceriesGroceryItemsAccessibility

struct GroceryListView: View {
    @FocusState private var isSearching: Bool
    @State private var showingAddButton = true
    @StateObject var viewModel: GroceryListViewModel
    
    var body: some View {
        VStack {
            GroceryListFilterControl(selectedFilter: $viewModel.filter)
                .setGroceryListIdAccessId(.filterControl)
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
                    .setGroceryListIdAccessId(.undoLastPurchaseButton)
                    .onlyShow(when: viewModel.hasPurchasedItems)
                
                GroceryItemList(viewModel: viewModel)
                    .setGroceryListIdAccessId(.groceryListTable)
                    .handlingVerticalPanGesture {
                        showingAddButton = $0 == .down
                    }
            }
            .withEmptyListView(listEmpty: viewModel.noDisplayableGroceries, listType: .groceries(viewModel.searchText))
            .withCircleAddButton(
                isShowing: $showingAddButton,
                accessibilityId: .accessId(.addNewItemButton),
                action: viewModel.addNewItem
            )
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
                    GroceryItemRow(item: item, shouldShowMarkets: viewModel.shouldShowMarkets) {
                        viewModel.showDetails(for: item)
                    }
                    .padding(.vertical)
                    .asyncTapGesture(asRowItem: .noChevron) {
                        try await viewModel.togglePurchased(item)
                    }
                    .withSwipeDelete(.deleteItemMessage) {
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
    let shouldShowMarkets: Bool
    let showDetails: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: showDetails) {
                    Image(systemName: "info.circle")
                        .tint(.darkGreen)
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                .setGroceryListIdAccessId(.groceryItemInfoButton)
                
                Text(item.name)
                    .withFont(autoSizeLineLimit: 2)
                    .opacity(item.purchased ? 0.5 : 1)
                
                Spacer()
                
                Text("Purchased")
                    .withFont(textColor: .red)
                    .setGroceryListIdAccessId(.groceryItemPurchasedLabel)
                    .onlyShow(when: item.purchased)
            }
            
            Text(item.marketNames)
                .withFont(.caption2, isDetail: true, textColor: .secondary)
                .setGroceryListIdAccessId(.groceryItemMarketsLabel)
                .onlyShow(when: shouldShowMarkets)
        }
    }
}


// MARK: - Preview
#Preview {
    return NavStack(title: "Groceries") {
        GroceryListView(viewModel: .init(datasource: .previewInit(), delegate: PreviewGroceryListDelegate(), onSelection: { _ in }))
            .withErrorHandling()
    }
}


// MARK: - Extension Dependencies
fileprivate extension GroceryItemCategory {
    var color: Color {
        return colorInfo.color
    }
}

fileprivate extension GroceryItem {
    var marketNames: String {
        if markets.isEmpty {
            return "Unassigned"
        }
        
        return markets.map({ $0.name }).joined(separator: ", ")
    }
}

fileprivate extension View {
    func setGroceryListIdAccessId(_ id: GroceryListAccessibilityId) -> some View {
        accessibilityIdentifier(id.rawValue)
    }
}

fileprivate extension String {
    static var deleteItemMessage: String {
        return "Are you sure you want to delete this item?"
            .nnSkipLine("It will be deleted from all stores.")
    }
    
    static func accessId(_ id: GroceryListAccessibilityId) -> String {
        return id.rawValue
    }
}
