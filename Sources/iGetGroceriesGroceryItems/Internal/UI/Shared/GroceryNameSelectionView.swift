//
//  GroceryNameSelectionView.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI

// TODO: - Move to SharedUI
public struct GroceryNameSelectionView<Item: GrocerySelectionData>: View {
    @Binding var name: String
    @FocusState var isTyping: Bool
    
    let prompt: String
    let showList: Bool
    let groceries: [Item]
    let onItemSelection: (Item) async throws -> Void
    
    public init(_ prompt: String = "Grocery Item...", name: Binding<String>, isTyping: FocusState<Bool>, showList: Bool, groceries: [Item], onItemSelection: @escaping (Item) async throws -> Void) {
        self._name = name
        self._isTyping = isTyping
        self.prompt = prompt
        self.showList = showList
        self.groceries = groceries
        self.onItemSelection = onItemSelection
    }
    
    public var body: some View {
        VStack {
            TextField(prompt, text: $name)
                .tint(.darkGreen)
                .focused($isTyping)
                .submitLabel(.done)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
            // TODO: -
//                .withRoundedShadowBorder(shadowColor: .primary)
            
            SingleSectionGroceryListView(groceries: groceries, onItemSelection: onItemSelection)
                .onlyShow(when: showList)
        }
    }
}


public struct SingleSectionGroceryListView<Item: GrocerySelectionData>: View {
    let groceries: [Item]
    let onItemSelection: (Item) async throws -> Void
    
    public init(groceries: [Item], onItemSelection: @escaping (Item) async throws -> Void) {
        self.groceries = groceries
        self.onItemSelection = onItemSelection
    }
    
    public var body: some View {
        List {
            Section("Exisiting Groceries") {
                ForEach(groceries) { item in
                    HStack {
                        Text(item.name)
                            .withFont()
                        
                        Spacer()
                        
                        Text("Purchased")
                            .withFont(textColor: .red)
                            .onlyShow(when: item.purchased)
                    }
                    .contentShape(Rectangle())
                    .asyncTapGesture {
                        try await onItemSelection(item)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}

public protocol GrocerySelectionData: Identifiable {
    var id: String { get }
    var name: String { get }
    var purchased: Bool { get }
}
