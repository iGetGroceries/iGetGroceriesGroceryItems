//
//  GroceryDetailView.swift
//  
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

struct GroceryDetailView: View {
    @State var name = ""
    @FocusState var fieldIsSelected: Bool
    @StateObject var viewModel: GroceryDetailViewModel
    
    var body: some View {
        VStack {
            GroceryNameSelectionView(
                name: $name,
                isTyping: _fieldIsSelected,
                showList: fieldIsSelected && viewModel.isNewItem,
                groceries: viewModel.existingItems,
                onItemSelection: viewModel.selectItem(_:)
            )
            
            VStack {
                Button(action: viewModel.resetItem) {
                    Text("Clear current item")
                        .padding(5)
                        .withFont()
                }
                .tint(.black)
                .buttonStyle(.bordered)
                .onlyShow(when: viewModel.showResetButton)
                
                // TODO: - IngredientView
                // TODO: - CategoryView
                // TODO: - AssignedStoresView
                // TODO: - PurchaseInfoView
                // TODO: - SaveButtons
            }
        }
        .mainBackground()
    }
}

// MARK: - Preview
#Preview {
    NavStack {
        GroceryDetailView(viewModel: .init())
    }
}


// MARK: - Extension Dependencies
extension GroceryItem: GrocerySelectionData { }
