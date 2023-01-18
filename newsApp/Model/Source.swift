//
//  Source.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation

class Source: Codable {
    let id: String?
    let name: String?
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
    
    init(id: String?, name: String?, description: String?, url: String?, category: String?, language: String?, country: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
}
