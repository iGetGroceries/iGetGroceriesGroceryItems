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
        XCTAssertNil(delegate.savedItem)
        XCTAssertNil(delegate.deletedItem)
        XCTAssertNil(delegate.selectedItem)
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
