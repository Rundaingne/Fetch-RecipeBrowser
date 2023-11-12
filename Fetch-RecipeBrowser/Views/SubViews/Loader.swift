//
//  Loader.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let ui = UIActivityIndicatorView()
        ui.color = .cyan
        return ui
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

struct Loader: View {
    
    var category: String
    
    var body: some View {
        VStack {
            Text("Loading \(category) Recipes...")
                .padding()
                .multilineTextAlignment(.center)
            
            ActivityIndicator(shouldAnimate: .constant(true), style: .large)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 8).fill(LinearGradient(colors: [.black, .gray.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)))
        .shadow(radius: 4)
    }
}
