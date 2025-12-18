//
//  TranslationModels.swift
//  AutoTranslate
//
//  Created by Pedro Muñoz Cabrera on 12/12/25.
//

// Trans 4.4 Add requiered imports
import SwiftUI
import UniformTypeIdentifiers

// Trans 4.1 Create Struct TranslationUnit
struct TranslationUnit: Codable {
    var state = "translated"
    var value: String
}

// Trans 4.2 Create Struct TranslationLanguage
struct TranslationLanguage: Codable {
    var stringUnit: TranslationUnit
}

// Trans 4.3 Create Struct TranslationString
struct TranslationString: Codable {
    var localizations = [String: TranslationLanguage]()
}

// Trans 4.5 Create extension from UTType
extension UTType {
    static var xcStrings = UTType("com.apple.xcode.xcstrings")!
}


// Trans 4.6 Create struct TranslationDocument
struct TranslationDocument: Codable, FileDocument {
    static var readableContentTypes = [UTType.xcStrings]

    var sourceLanguage: String
    var strings: [String: TranslationString]
    var version = "1.0"
    
    // Trans 4.7 Create constructors
    init(sourceLanguage: String, strings: [String: TranslationString] = [:]) {
        self.sourceLanguage = sourceLanguage
        self.strings = strings
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self = try JSONDecoder().decode(TranslationDocument.self, from: data)
        } else {
            sourceLanguage = "en"
            strings = [:]
        }
    }
    
    // Trans 4.8 Create func fileWrapper
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(self)
        return FileWrapper(regularFileWithContents: data)
    }

}
