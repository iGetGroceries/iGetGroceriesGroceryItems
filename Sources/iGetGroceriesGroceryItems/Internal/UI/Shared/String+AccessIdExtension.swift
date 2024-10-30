//
//  String+AccessIdExtension.swift
//
//
//  Created by Nikolai Nobadi on 10/23/24.
//

import iGetGroceriesGroceryItemsAccessibility

/// Provides an accessibility identifier string for a given `GroceryListAccessibilityId`.
/// - Parameter id: The accessibility ID for the grocery list.
/// - Returns: A `String` value representing the accessibility identifier.
extension String {
    static func accessId(_ id: GroceryListAccessibilityId) -> String {
        return id.rawValue
    }
}
