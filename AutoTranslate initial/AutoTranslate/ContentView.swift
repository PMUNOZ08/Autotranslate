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

    // Trans 2.2 (Create languages)
  
    // Trans 2.4 (Create vars for language trnaslating)

    // Trans 2.5 (Create enum and property for trnaslation state)

    // Trans 4.9 Create vars to show Exporter

    var body: some View {
        // Trans 2.3 (SplitView selector languages)
        TextEditor(text: $input)
            .font(.largeTitle)
       
        // Trans 1.2 (perform Trnaslation Task

        // Trans 1.4 (invalidate configuration)

        // Trans 3.2 (Update languages when change selection)

        // Trans 4.11 add modifier FileEXporter

    }
    // Trans 1.1 (Add translation Task)
    
    // Trans 2.7 (Replace translate function to allow several languages)

    
    // Trans 2.6 (Create doNextTranslation function )

    
    // Trans 2.8 (Create func createAllTrnaslations)
    
    // Trans 3.1 (Create function updateLanguages)
    
    // Trans 4.10 create function to handle save result
    
}

#Preview {
    ContentView()
}
