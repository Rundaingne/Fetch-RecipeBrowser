//
//  SearchBar.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct SearchBar: View {
    
    var placeholder: String
    @Binding var text: String
    
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

