
# iGetGroceriesGroceryItems Module

The **iGetGroceriesGroceryItems** Swift Package is a core module for the **iGetGroceries** app, designed to manage grocery list functionality efficiently and reliably. This module is made public as a demonstration of clean, organized code and to showcase development practices. While it’s intended for use within the **iGetGroceries** app, this package can serve as a reference for similar grocery management apps.

## Features

- **Grocery Item Management**: Define and manage grocery items with properties like `name`, `category`, `purchased` status, and associated `markets`.
- **Category Organization**: Organize items into categories with customizable color coding.
- **User Permissions**: Control item limit restrictions for guests and standard users.
- **Preview and Testing Utilities**: Easily create sample data for SwiftUI previews and testing.
- **UI Components**: Ready-to-use SwiftUI views and view modifiers for displaying and interacting with grocery items.
- **Accessibility Support**: Streamlined access to accessibility identifiers for testing and UI automation.

## Installation

To install this package, add the following line to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/iGetGroceries/iGetGroceriesGroceryItems.git", from: "1.0.0")
```

Then add `iGetGroceriesGroceryItems` as a dependency in your target.

## Usage

### 1. Creating Grocery Items and Categories

The `GroceryItem` struct represents an individual grocery item, and `GroceryItemCategory` organizes these items into distinct groups.

Example:
```swift
let groceryItem = GroceryItem(id: "1", name: "Apples", purchased: false, markets: [], categoryId: "produce", oneTimePurchase: false)
let category = GroceryItemCategory(id: "produce", name: "Produce", items: [groceryItem], colorInfo: .green)
```

### 2. Displaying and Managing Items

Use `GroceryListView` to display the grocery items. You can configure the view model, `GroceryListViewModel`, to manage search, filter, and item state toggling.

Example:
```swift
GroceryListView(viewModel: GroceryListViewModel(datasource: dataSource, delegate: delegate) { item in
    // Handle item selection
})
```

### 3. Sample Data for Previews

Use the `PreviewContent` extensions to create sample data for SwiftUI previews. This includes sample grocery items, categories, and user configurations.

Example:
```swift
let sampleCategories = GroceryItemCategory.sampleList
let sampleUser = GroceryUser.sample
let sampleDataSource = GroceryDataSource.previewInit(user: sampleUser, categories: sampleCategories)
```

## License

This package is released under the MIT license.
