//
//  ImageLoaderTests.swift
//  MortyverseExplorerTests
//
//  Created by Khalid on 21/10/2024.
//

import XCTest
@testable import MortyverseExplorer

final class ImageLoaderTests: XCTestCase {
    
    func test_download_image_success() throws {
        // Given
        let stub = ImageLoaderStub(result: .success(UIImage()))

        var returnedError: Error?
        var downloadedImage: UIImage?

        // When
        let expectation = self.expectation(description: "test_download_image_success")
        let dummyURL = URL.init(string: "www.apple.com")!

        stub.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                downloadedImage = image
                expectation.fulfill()
            case let .failure(error):
                returnedError = error
                expectation.fulfill()
            }
        }

        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(downloadedImage)
    }
    
    func test_download_image_failure() throws {
        // Given
        let stub = ImageLoaderStub(result: .failure(NetworkError.outdated))

        var returnedError: Error?
        var downloadedImage: UIImage?

        // When
        let expectation = self.expectation(description: "test_download_image_failure")
        let dummyURL = URL.init(string: "www.apple.com")!

        stub.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                downloadedImage = image
                expectation.fulfill()
            case let .failure(error):
                returnedError = error
                expectation.fulfill()
            }
        }

        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(returnedError)
        XCTAssertNil(downloadedImage)
    }
}

class ImageLoaderStub: ImageDownloadable {
    var result: Result<UIImage, Error>
    init(result: Result<UIImage, Error>) {
        self.result = result
    }
    
    func fetchImage(from imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        completion(result)
    }
}
