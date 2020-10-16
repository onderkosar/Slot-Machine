//
//  LogoView.swift
//  Slot Machine
//
//  Created by Önder Koşar on 16.10.2020.
//

import SwiftUI

struct LogoView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        SMImages.slotMachine
            .resizable()
            .scaledToFit()
            .frame(minWidth: 256, idealWidth: 300, maxWidth: 320, minHeight: 112, idealHeight: 130, maxHeight: 140, alignment: .center)
            .padding(.horizontal)
            .layoutPriority(1)
            .modifier(ShadowModifier())
    }
}

// MARK: - PREVIEW
struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
            .previewLayout(.sizeThatFits)
    }
}
