//
//  ContentView.swift
//  Slot Machine
//
//  Created by Önder Koşar on 15.10.2020.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // MARK: - BACKGROUND
            LinearGradient(gradient: Gradient(colors: [SMColors.pink, SMColors.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // MARK: INTERFACE
            VStack(alignment: .center, spacing: 5) {
                // MARK: - HEADER
                LogoView()
                Spacer()
                
                // MARK: - SCORE
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("100")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    } // HStack (Coins)
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("200")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    } // HStack (Score)
                    .modifier(ScoreContainerModifier())
                }
                
                // MARK: - SLOT MACHINE
                
                
                // MARK: - FOOTER
                Spacer()
                
            } // VStack
            // MARK: - BUTTONS
            .overlay(
                // RESET
                Button(action: {
                    print("Reset the game")
                }) {
                    SMSymbols.reset
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                // INFO
                Button(action: {
                    print("Info View")
                }) {
                    SMSymbols.info
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            
            .padding()
            .frame(maxWidth: 720)
            
            // MARK: POPUP
            
            
        } // ZStack
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
