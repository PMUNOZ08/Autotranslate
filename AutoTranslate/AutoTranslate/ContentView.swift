//
//  ContentView.swift
//  AutoTrnaslate
//
//  Created by Pedro Muñoz Cabrera on 12/12/25.
//

import SwiftUI
import Translation

struct ContentView: View {
    @State private var input = "Hello, world"
    // Trans 1.3 (Create TranslationSession, add to translationTask
    @State private var configuration = TranslationSession.Configuration(
        source: Locale.Language(identifier: "en"),
        target: Locale.Language(identifier: "fr")
    )
    // Trans 2.2 (Create languages)
    @State private var languages = [
        Language(id: "ar", name: "Arabic", isSelected: false),
        Language(id: "zh", name: "Chinese", isSelected: false),
        Language(id: "nl", name: "Dutch", isSelected: false),
        Language(id: "fr", name: "French", isSelected: false),
        Language(id: "de", name: "German", isSelected: false),
        Language(id: "hi", name: "Hindi", isSelected: false),
        Language(id: "in", name: "Indonesian", isSelected: false),
        Language(id: "it", name: "Italian", isSelected: false),
        Language(id: "ja", name: "Japanese", isSelected: false),
        Language(id: "ko", name: "Korean", isSelected: false),
        Language(id: "pl", name: "Polish", isSelected: false),
        Language(id: "pt", name: "Portuguese", isSelected: false),
        Language(id: "ru", name: "Russian", isSelected: false),
        Language(id: "es", name: "Spanish", isSelected: true),
        Language(id: "th", name: "Thai", isSelected: false),
        Language(id: "tr", name: "Turkish", isSelected: false),
        Language(id: "uk", name: "Ukrainian", isSelected: false),
        Language(id: "vi", name: "Vietnamese", isSelected: false),
    ]
    
    // Trans 2.4 (Create vars for language trnaslating)
    @State private var translatingLanguages = [Language]()
    @State private var languageIndex = Int.max
    
    // Trans 2.5 (Create enum and property for trnaslation state)
    enum TranslationState {
        case waiting, creating, done
    }
    @State private var translationState = TranslationState.waiting
    
    // Trans 4.9 Create vars to show Exporter
    @State private var showingExporter = false
    @State private var document = TranslationDocument(sourceLanguage: "en")
    
    var body: some View {
        // Trans 2.3 (SplitView selector languages)
        NavigationSplitView {
            ScrollView {
                Form {
                    ForEach($languages) { $language in
                        Toggle(language.name, isOn: $language.isSelected)
                    }
                }
            }
        } detail: {
            // Trans 2.9 ( Add button to create all trnaslations)
            VStack(spacing: 0) {
                TextEditor(text: $input)
                    .font(.largeTitle)
                // Trans 3.5 (Replace button, to show state on trnaslation)
                Group {
                    switch translationState {
                    case .waiting:
                        Button("Create Translations", action: createAllTranslations)
                    case .creating:
                        ProgressView()
                    case .done:
                        // Trans 4.12 Replace Done text by button to export
                        Button("Export") {
                            showingExporter = true
                        }
                    }
                }
                .frame(height: 60)
            }
        }
        // Trans 1.2 (perform Trnaslation Task
            .translationTask(configuration, action: translate)
        // Trans 1.4 (invalidate configuration)
            .onChange(of: input) {
                // Trans 3.4 (REplace invalidate by state to waiting)
                translationState = .waiting
            }
        // Trans 3.2 (Update languages when change selection)
            .onChange(of: languages, updateLanguages)
        // Trans 4.11 add modifier FileEXporter
            .fileExporter(isPresented: $showingExporter, document: document, contentType: .xcStrings, defaultFilename: "Localizable", onCompletion: handleSaveResult)
    }
    // Trans 1.1 (Add translation Task)
    // Trans 2.7 (Replace translate function to allow several languages)
    func translate(using session: TranslationSession) async {
        do {
            // Trans 3.3 (Prepare session when waiting)
            if translationState == .waiting {
                try await session.prepareTranslation()
            } else if translationState == .creating {
                // Trans 4.13  Convert string to requests
                let inputStrings = input.components(separatedBy: .newlines)

                let requests = inputStrings.map { TranslationSession.Request(sourceText: $0) }

                for response in try await session.translations(from: requests) {
                    // Trans 4.14  Process requests
                    let translationUnit = TranslationUnit(value: response.targetText)
                    var currentTranslationString = document.strings[response.sourceText] ?? TranslationString()
                    currentTranslationString.localizations[response.targetLanguage.minimalIdentifier] = TranslationLanguage(stringUnit: translationUnit)
                    document.strings[response.sourceText] = currentTranslationString
                }
                
                languageIndex += 1
                doNextTranslation()
            }
        } catch {
            print(error.localizedDescription)
            translationState = .waiting
        }
    }
    
    // Trans 2.6 (Create doNextTranslation function )
    func doNextTranslation() {
        guard languageIndex < translatingLanguages.count else {
            translationState = .done
            return
        }
        
        let language = translatingLanguages[languageIndex]
        configuration.source = Locale.Language(identifier: "en")
        configuration.target = Locale.Language(identifier: language.id)
        configuration.invalidate()
    }
    
    // Trans 2.8 (Create func createAllTrnaslations)
    func createAllTranslations() {
        translatingLanguages = languages.filter(\.isSelected)
        languageIndex = 0
        translationState = .creating
        // Trans 4.15 clear strings in document
        document.strings.removeAll()
        
        doNextTranslation()
    }
    
    // Trans 3.1 (Create function updateLanguages)
    func updateLanguages(oldValue: [Language], newValue: [Language]) {
        let oldSet = Set(oldValue.filter(\.isSelected))
        let newSet = Set(newValue.filter(\.isSelected))

        // Subtract the old languages from the new languages.
        let difference = newSet.subtracting(oldSet)

        // Check to see if we had an addition.
        if let newLanguage = difference.first {
            configuration.source = Locale.Language(identifier: newLanguage.id)
            configuration.invalidate()
        }

        translationState = .waiting
    }
    
    // Trans 4.10 create function to handle save result
    func handleSaveResult(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            print("Saved to \(url)")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    ContentView()
}
