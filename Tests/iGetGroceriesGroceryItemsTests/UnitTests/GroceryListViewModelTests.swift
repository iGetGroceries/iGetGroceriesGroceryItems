//
//  GroceryListViewModelTests.swift
//
//
//  Created by Nikolai Nobadi on 8/27/24.
//

import XCTest
import NnTestHelpers
@testable import iGetGroceriesGroceryItems

final class GroceryListViewModelTests: XCTestCase {
    func test_starting_values_are_empty() {
        let (sut, delegate) = makeSUT()
        
        XCTAssert(sut.searchText.isEmpty)
        XCTAssertFalse(sut.hasPurchasedItems)
        XCTAssertNil(delegate.savedItem)
        XCTAssertNil(delegate.deletedItem)
        XCTAssertNil(delegate.selectedItem)
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
    
    func test_purchased_items_are_not_purchased_after_toggling() {
        
    }
    
    func test_unpurchased_items_are_purchased_after_toggling() {
        
    }
    
    func test_hasPurchasedItems_updates_after_toggling_items() {
        
    }
    
    func test_deletes_item() {
        
    }
    
    func test_deleting_a_purchased_item_removes_it_from_purchased_list() {
        
    }
    
    func test_items_are_unpurchased_when_undoing_last_purchased() {
        
    }
    
    func test_most_recent_purchased_item_is_removed_from_list_when_undoing_last_purhase() {
        
    }
}


// MARK: - SUT
extension GroceryListViewModelTests {
    func makeSUT(throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: GroceryListViewModel, delegate: MockDelegate) {
        let datasource = GroceryDataSource()
        let delegate = MockDelegate(throwError: throwError)
        let sut = GroceryListViewModel(datasource: datasource, delegate: delegate, onSelection: delegate.onSelection(_:))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate)
    }
    
    func makeItem(id: String = "itemId", purchased: Bool = false) -> GroceryItem {
        return .init(id: id, name: "", purchased: purchased, marketIds: [], categoryId: "", oneTimePurchase: false)
    }
}


// MARK: - Helper Classes
extension GroceryListViewModelTests {
    class MockDelegate: GroceryListDelegate {
        private let throwError: Bool
        private(set) var savedItem: GroceryItem?
        private(set) var deletedItem: GroceryItem?
        private(set) var selectedItem: GroceryItem?
        
        init(throwError: Bool) {
            self.throwError = throwError
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
