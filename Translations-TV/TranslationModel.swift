//
//  Translation.swift
//  Translations-TV
//
//  Created by Brian Veitch on 2/26/22.
//

import Foundation

struct Translation: Codable {
    var contents: Contents
}

struct Contents: Codable {
    var translated: String
    var text: String
    var translation: String
}
