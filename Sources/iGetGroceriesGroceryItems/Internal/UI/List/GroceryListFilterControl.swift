//
//  GroceryListFilterControl.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iGetGroceriesSharedUI

struct GroceryListFilterControl: View {
    @Binding var selectedFilter: GroceryListFilterOption
    
    var body: some View {
        Picker("", selection: $selectedFilter.animation()) {
            ForEach(GroceryListFilterOption.allCases, id: \.self) { option in
                Text(option.rawValue)
            }
        }
        .frame(width: getWidthPercent(90))
        .pickerStyle(.segmented)
        .padding([.top])
        .onAppear {
            setSegmentedPickerAppearance()
        }
    }
}
