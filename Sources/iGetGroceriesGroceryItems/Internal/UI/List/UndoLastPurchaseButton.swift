//
//  UndoLastPurchaseButton.swift
//
//
//  Created by Nikolai Nobadi on 8/27/24.
//

import SwiftUI
import iGetGroceriesSharedUI

/// A button to undo the last purchase in the grocery list.
struct UndoLastPurchaseButton: View {
    let action: () async throws -> Void
    
    var body: some View {
        AsyncTryButton(action: action) {
            Text("Undo Last Purchase")
                .padding(5)
                .withFont(textColor: .darkGreen)
        }
        .tint(.darkGreen)
        .buttonStyle(.bordered)
    }
}
