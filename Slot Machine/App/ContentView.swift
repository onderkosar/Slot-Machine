//
//  ContentView.swift
//  Slot Machine
//
//  Created by Önder Koşar on 15.10.2020.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    let symbols = [SMImageName.bell, SMImageName.cherry, SMImageName.coin, SMImageName.grape, SMImageName.seven, SMImageName.strawberry]
    
    @State private var highscore: Int = 0
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    
    @State private var isActiveBet10: Bool = true
    // MARK: - MAIN FUNCTIONS
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
    }
    
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            // PLAYER WINS
            playerWins()
            
            // NEW HIGHSCORE
            if coins > highscore { newHighscore() }
            
        } else {
            // PLAYER LOSES
            playerLoses()
        }
    }
    
    // GAME IS OVER
    
    
    // MARK: - SUB FUNCTIONS
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighscore() {
        highscore = coins
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isActiveBet10 = false
    }
    
    func activateBet10() {
        betAmount = 10
        isActiveBet10 = true
    }
    
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
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    } // HStack (Coins)
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    } // HStack (Score)
                    .modifier(ScoreContainerModifier())
                }
                
                // MARK: - SLOT MACHINE
                VStack(alignment: .center, spacing: 0) {
                    // REEL #1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                    } // ZStack Reel #1
                    
                    HStack(alignment: .center, spacing: 0) {
                        // REEL #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        
                        Spacer()
                        
                        // REEL #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    } // HStack Reel #2 & #3
                    .frame(maxWidth: 500)
                    
                    // MARK: - SPIN BUTTON
                    Button(action: {
                        self.spinReels()
                        self.checkWinning()
                    }) {
                        Image(SMImageName.spin)
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    } // Spin Button
                    
                } // Slot Machine
                .layoutPriority(2)
                
                // MARK: - FOOTER
                Spacer()
                
                HStack {
                    // BET 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            self.activateBet20()
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color.white : SMColors.yellow)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image(SMImageName.casinoChips)
                            .resizable()
                            .opacity(isActiveBet10 ? 0 : 1)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    // BET 10
                    HStack(alignment: .center, spacing: 10) {
                        Image(SMImageName.casinoChips)
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            self.activateBet10()
                        }) {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? SMColors.yellow : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
            
            // MARK: - BUTTONS
            .overlay(
                // RESET
                Button(action: {
                    print("Reset the game")
                }) {
                    Image(systemName: SFSymbolName.reset)
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                // INFO
                Button(action: {
                    self.showingInfoView = true
                }) {
                    Image(systemName: SFSymbolName.info)
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            
            .padding()
            .frame(maxWidth: 720)
            
            // MARK: - POPUP
        } // ZStack
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
