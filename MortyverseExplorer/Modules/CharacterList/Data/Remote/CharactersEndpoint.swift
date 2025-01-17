//
//  CharactersEndpoint.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/09/2024.
//

import Foundation

enum CharactersEndpoint: BaseEndpoint {
    case getCharacters(page: Int)
    
    var path: String {
        switch self {
        case .getCharacters:
            return "character"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCharacters:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getCharacters(let page):
            return ["page": page]
        }
    }
}
