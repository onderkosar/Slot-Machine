//
//  ReelView.swift
//  Slot Machine
//
//  Created by Önder Koşar on 16.10.2020.
//

import SwiftUI

struct ReelView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        Image(SMImageName.reel)
            .resizable()
            .modifier(ImageModifier())
    }
}

// MARK: - PREVIEW
struct ReelView_Previews: PreviewProvider {
    static var previews: some View {
        ReelView()
            .previewLayout(.fixed(width: 220, height: 220))
    }
}
