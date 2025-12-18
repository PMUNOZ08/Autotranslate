//
//  Language.swift
//  AutoTranslate
//
//  Created by Pedro Muñoz Cabrera on 12/12/25.
//

import Foundation

// Trans 2.1 Create Struct Language
struct Language: Hashable, Identifiable {
    var id: String
    var name: String
    var isSelected: Bool
}
