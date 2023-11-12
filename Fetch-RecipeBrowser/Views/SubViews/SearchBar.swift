//
//  SearchBar.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct SearchBar: View {
    /// Make a custom search bar with a simple rounded rectangular background.
    
    var placeholder: String
    @Binding var text: String
    
    /// Doesn't really do anything here, but can be useful if you wanted to move between FocusedStates/FocusField, etc. Or just use the @Focused property wrapper instead, eh.
    var onSubmit: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .padding(4)
                
                TextField("", text: $text)
                    .padding(8)
                    .textFieldStyle(VisiblePlaceholderStyle(placeholder, text: $text))
                    .onSubmit {
                        onSubmit()
                    }

                Spacer()
                
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .opacity(0.5)
                    .onTapGesture {
                        text.removeAll()
                    }
                    .isHidden(text.isEmpty)
                    .padding(.trailing)
            }
            .foregroundColor(.gray)
            .background(RoundedRectangle(cornerRadius: 4).fill(Color.black.opacity(0.5)))
        }
    }
}

