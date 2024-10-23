//
//  String+AccessIdExtension.swift
//
//
//  Created by Nikolai Nobadi on 10/23/24.
//

import iGetGroceriesGroceryItemsAccessibility

extension String {
    static func accessId(_ id: GroceryListAccessibilityId) -> String {
        return id.rawValue
    }
}
