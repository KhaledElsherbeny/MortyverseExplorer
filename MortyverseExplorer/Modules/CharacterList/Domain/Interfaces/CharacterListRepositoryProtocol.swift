//
//  DriverPerformanceRepositoryProtocol.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/09/2024.
//

import Combine
import Foundation

protocol CharacterListRepositoryProtocol {
    func fetchCharacters(at page: Int) -> AnyPublisher<CharacterList, NetworkError>
}
