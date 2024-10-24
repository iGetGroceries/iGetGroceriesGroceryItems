//
//  ToggleItemPurchaseViewModifier.swift
//
//
//  Created by Nikolai Nobadi on 10/23/24.
//

import SwiftUI
import iGetGroceriesSharedUI
import iGetGroceriesGroceryItemsAccessibility

struct ToggleItemPurchaseViewModifier: ViewModifier {
    @ObservedObject var viewModel: GroceryListViewModel
    @State private var showingOneTimePurchaseConfirmation = false
    
    let item: GroceryItem
    
    func body(content: Content) -> some View {
        content
            .asyncTapGesture(asRowItem: .noChevron) {
                try await onTapGesture()
            }
            .asyncConfirmation(
                .oneTimePurchaseMessage,
                showingConfirmation: $showingOneTimePurchaseConfirmation,
                role: .destructive,
                buttonInfo: .init(prompt: "Purchase & Delete", accessibilityId: .accessId(.oneTimePurchaseAlertPurchaseButton)),
                action: deleteItem
            )
    }
}


// MARK: - Private Methods
private extension ToggleItemPurchaseViewModifier {
    func deleteItem() async throws {
        try await viewModel.deleteItem(item)
    }
    
    func onTapGesture() async throws {
        if item.oneTimePurchase {
            showingOneTimePurchaseConfirmation = true
        } else {
            try await viewModel.togglePurchased(item)
        }
    }
}


// MARK: - Extension Dependencies
extension View {
    func togglePurchasedOnTapGesture(item: GroceryItem, viewModel: GroceryListViewModel) -> some View {
        modifier(ToggleItemPurchaseViewModifier(viewModel: viewModel, item: item))
    }
}

fileprivate extension String {
    static var oneTimePurchaseMessage: String {
        return "This item was marked as a One-Time Purchase."
            .nnSkipLine("It will be deleted from your shopping lists once it has been purchased.")
    }
}
