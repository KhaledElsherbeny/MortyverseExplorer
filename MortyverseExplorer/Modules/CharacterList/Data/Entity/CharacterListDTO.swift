//
//  CharacterListDTO.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/09/2024.
//

import Foundation

struct CharacterListDTO: Codable {
    let info: CharacterListPageInfoDTO?
    let results: [CharacterListItemDTO]?
}

struct CharacterListPageInfoDTO: Codable {
    let count, pages: Int?
    let next: String?
    let prev: String?
}

struct CharacterListItemDTO: Codable {
    let id: Int?
    let name: String?
    let status: Status?
    let species: String?
    let type: String?
    let gender: String?
    let origin, location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

struct Location: Codable {
    let name: String?
    let url: String?
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
