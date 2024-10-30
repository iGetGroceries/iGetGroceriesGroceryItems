//
//  GroceryListFilterControl.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI
import iGetGroceriesGroceryItemsAccessibility

/// A control for filtering grocery list items based on specific criteria.
struct GroceryListFilterControl: View {
    @Binding var selectedFilter: GroceryListFilterOption
    
    var body: some View {
        Picker("", selection: $selectedFilter.animation()) {
            ForEach(GroceryListFilterOption.allCases, id: \.self) { option in
                Text(option.rawValue)
            }
        }
        .padding([.top])
        .pickerStyle(.segmented)
        .frame(width: getWidthPercent(90))
        .setAccessibiltyId(.accessId(.filterControl))
        .onAppear {
            setSegmentedPickerAppearance()
        }
    }
}
