//
//  VisiblePlaceholder.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct VisiblePlaceholderStyle: TextFieldStyle {
    let placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            if text.isEmpty {
                Text(placeholder)
            }
            configuration
        }.foregroundColor(.white)
    }
}
