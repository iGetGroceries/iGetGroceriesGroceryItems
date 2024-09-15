//
//  GroceryListViewModelTests.swift
//
//
//  Created by Nikolai Nobadi on 8/27/24.
//

import XCTest
import Combine
import NnTestHelpers
@testable import iGetGroceriesGroceryItems

final class GroceryListViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        super.tearDown()
    }
}


// MARK: - Unit Tests
extension GroceryListViewModelTests {
    func test_starting_values_are_empty() {
        let (sut, delegate) = makeSUT()
        
        XCTAssert(sut.searchText.isEmpty)
        XCTAssertFalse(sut.hasPurchasedItems)
        XCTAssertNil(delegate.savedItem)
        XCTAssertNil(delegate.deletedItem)
        XCTAssertNil(delegate.selectedItem)
    }
    
    func test_categories_are_filtered_pending_on_search_text() {
        let categories = makeSampleCategoryList()
        let sut = makeSUT(categories: categories, groceryItemLimit: 2).sut
        
        waitForCondition(publisher: sut.$categories, cancellables: &cancellables, condition: { !$0.isEmpty })
        
        sut.searchText = "Appl"
        
        waitForCondition(publisher: sut.$categories, cancellables: &cancellables) { list in
            return list.flatMap({ $0.items }).count == 1
        }
        
        XCTAssertEqual(sut.categories.count, 1)
    }
    
    func test_categories_are_filtered_pending_on_grocery_filter() {
        let categories = makeSampleCategoryList()
        let sut = makeSUT(categories: categories, groceryItemLimit: 2).sut
        
        waitForCondition(publisher: sut.$allGroceries, cancellables: &cancellables, condition: { !$0.isEmpty })
        
        let initialCategoryCount = sut.categories.count
        
        sut.filter = .hidePurchased
        
        waitForCondition(publisher: sut.$categories, cancellables: &cancellables, condition: { $0.count != initialCategoryCount })
        
        XCTAssertEqual(sut.categories.count, 1)
    }
    
    func test_shows_details_for_selected_item() {
        let item = makeItem()
        let (sut, delegate) = makeSUT()
        
        sut.showDetails(for: item)
        
        assertPropertyEquality(delegate.selectedItem, expectedProperty: item)
    }
    
    func test_shows_details_for_newly_added_item() throws {
        let (sut, delegate) = makeSUT()
        
        assertNoErrorThrown(action: sut.addNewItem)
        assertProperty(delegate.selectedItem) { item in
            XCTAssert(item.id.isEmpty)
            XCTAssertFalse(item.purchased)
        }
    }
    
    func test_throws_error_when_adding_a_new_item_when_current_max_item_limit_has_been_reached() {
        let categories = makeSampleCategoryList()
        let sut = makeSUT(categories: categories, groceryItemLimit: 2).sut
        
        waitForCondition(publisher: sut.$allGroceries, cancellables: &cancellables, condition: { !$0.isEmpty })
        assertThrownError(expectedError: GroceryListError.maxLimitReaced, action: sut.addNewItem)
    }
    
    func test_purchased_items_are_not_purchased_after_toggling() async {
        let purchasedItem = makeItem(purchased: true)
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.togglePurchased(purchasedItem)
        }
        
        assertProperty(delegate.savedItem) { item in
            XCTAssertFalse(item.purchased)
            XCTAssertEqual(item.id, purchasedItem.id)
        }
    }
    
    func test_unpurchased_items_are_purchased_after_toggling() async {
        let unpurchasedItem = makeItem(purchased: false)
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.togglePurchased(unpurchasedItem)
        }
        
        assertProperty(delegate.savedItem) { item in
            XCTAssert(item.purchased)
            XCTAssertEqual(item.id, unpurchasedItem.id)
        }
    }
    
    func test_unpurchased_items_are_added_to_purchased_list_as_purchased_after_toggling() async {
        let unpurchasedItem = makeItem(purchased: false)
        let sut = makeSUT().sut
        
        await asyncAssertNoErrorThrown {
            try await sut.togglePurchased(unpurchasedItem)
        }
        
        XCTAssert(sut.hasPurchasedItems)
    }
    
    func test_purchased_items_are_removed_from_purchased_list_after_toggling() async {
        let purchasedItem = makeItem(purchased: true)
        let sut = makeSUT(purchasedItems: [purchasedItem]).sut
        
        XCTAssert(sut.hasPurchasedItems)
        
        await asyncAssertNoErrorThrown {
            try await sut.togglePurchased(purchasedItem)
        }
        
        XCTAssertFalse(sut.hasPurchasedItems)
    }
    
    func test_deletes_item() async {
        let item = makeItem()
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.deleteItem(item)
        }
        
        assertPropertyEquality(delegate.deletedItem, expectedProperty: item)
    }
    
    func test_deleting_a_purchased_item_removes_it_from_purchased_list() async {
        let purchasedItem = makeItem(purchased: true)
        let sut = makeSUT(purchasedItems: [purchasedItem]).sut
        
        XCTAssert(sut.hasPurchasedItems)
        
        await asyncAssertNoErrorThrown {
            try await sut.deleteItem(purchasedItem)
        }
        
        XCTAssertFalse(sut.hasPurchasedItems)
    }
    
    func test_items_are_unpurchased_when_undoing_last_purchased() async {
        let purchasedItem = makeItem(purchased: true)
        let (sut, delegate) = makeSUT(purchasedItems: [purchasedItem])
        
        await asyncAssertNoErrorThrown(action: sut.undoLastPurchase)

        assertProperty(delegate.savedItem) { item in
            XCTAssertFalse(item.purchased)
            XCTAssertEqual(item.id, purchasedItem.id)
        }
    }
    
    func test_most_recent_purchased_item_is_removed_from_list_when_undoing_last_purchase() async {
        let firstPurchasedItem = makeItem(id: "first", purchased: true)
        let secondPurchasedItem = makeItem(id: "second", purchased: true)
        let purchasedItems = [firstPurchasedItem, secondPurchasedItem]
        let (sut, delegate) = makeSUT(purchasedItems: purchasedItems)
        
        XCTAssert(sut.hasPurchasedItems)
        
        await asyncAssertNoErrorThrown(action: sut.undoLastPurchase)
        
        XCTAssert(sut.hasPurchasedItems)
        assertProperty(delegate.savedItem) { item in
            XCTAssertFalse(item.purchased)
            XCTAssertEqual(item.id, secondPurchasedItem.id)
        }
        
        await asyncAssertNoErrorThrown(action: sut.undoLastPurchase)
        
        XCTAssertFalse(sut.hasPurchasedItems)
        assertProperty(delegate.savedItem) { item in
            XCTAssertFalse(item.purchased)
            XCTAssertEqual(item.id, firstPurchasedItem.id)
        }
    }
    
    func test_unpurchased_items_are_deleted_after_toggling_when_they_are_one_time_purchases() async {
        let unpurchasedItem = makeItem(purchased: false, oneTimePurchase: true)
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.togglePurchased(unpurchasedItem)
        }
        
        XCTAssertNil(delegate.savedItem)
        assertPropertyEquality(delegate.deletedItem, expectedProperty: unpurchasedItem)
    }
}


// MARK: - SUT
extension GroceryListViewModelTests {
    func makeSUT(categories: [GroceryItemCategory] = [], purchasedItems: [GroceryItem] = [], groceryItemLimit: Int? = nil, throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: GroceryListViewModel, delegate: MockDelegate) {
        let datasource = GroceryDataSource(categories: categories, showingAllGroceries: true)
        let delegate = MockDelegate(throwError: throwError, groceryItemLimit: groceryItemLimit)
        let sut = GroceryListViewModel(datasource: datasource, delegate: delegate, purchasedItems: purchasedItems, onSelection: delegate.onSelection(_:))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate)
    }
    
    func makeItem(id: String = "itemId", name: String = "", purchased: Bool = false, oneTimePurchase: Bool = false) -> GroceryItem {
        return .init(id: id, name: name, purchased: purchased, markets: [], categoryId: "", oneTimePurchase: oneTimePurchase)
    }
    
    func makeCategory(id: String = "categoryId", items: [GroceryItem] = []) -> GroceryItemCategory {
        return .init(id: id, name: "", items: items, colorInfo: .green)
    }
    
    func makeSampleCategoryList() -> [GroceryItemCategory] {
        let firstItem = makeItem(id: "1", name: "Apple")
        let secondItem = makeItem(id: "2", name: "Banana")
        let firstCategory = makeCategory(id: "first", items: [firstItem, secondItem])
        let thirdItem = makeItem(id: "10", name: "Milk", purchased: true)
        let fourthItem = makeItem(id: "20", name: "Cheese", purchased: true)
        let secondCategory = makeCategory(id: "second", items: [thirdItem, fourthItem])
        
        return [firstCategory, secondCategory]
    }
}


// MARK: - Helper Classes
extension GroceryListViewModelTests {
    class MockDelegate: GroceryListDelegate {
        private let throwError: Bool
        private(set) var savedItem: GroceryItem?
        private(set) var deletedItem: GroceryItem?
        private(set) var selectedItem: GroceryItem?
        
        let groceryItemLimit: Int?
        
        init(throwError: Bool, groceryItemLimit: Int?) {
            self.throwError = throwError
            self.groceryItemLimit = groceryItemLimit
        }
        
        func saveItem(_ item: GroceryItem) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            self.savedItem = item
        }
        
        func deleteItem(_ item: GroceryItem) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            self.deletedItem = item
        }
        
        func onSelection(_ item: GroceryItem) {
            self.selectedItem = item
        }
    }
}
