//
//  ImageDownloader.swift
//  MortyverseExplorer
//
//  Created by Khalid on 28/08/2022.
//  Copyright © 2022 Khalid. All rights reserved.
//

import AlamofireImage
import UIKit

/// Protocol defining the functionality for downloading images.
protocol ImageDownloadable {
    /// Fetches an image from a specified URL.
    /// - Parameters:
    ///   - imageUrl: The URL of the image to download.
    ///   - completion: A closure to be executed once the image download is complete.
    func fetchImage(from imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

/// Class responsible for downloading images using AlamofireImage.
final class ImageDownloader: ImageDownloadable {
    /// Default shared instance of the image downloader.
    public static let shared = ImageDownloader()
    
    /// Fetches an image from a specified URL.
    /// - Parameters:
    ///   - imageUrl: The URL of the image to download.
    ///   - completion: A closure to be executed once the image download is complete.
    func fetchImage(from imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let request = URLRequest(url: imageUrl)
        AlamofireImage.ImageDownloader.default.download(request, completion:  { response in
            switch response.result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

