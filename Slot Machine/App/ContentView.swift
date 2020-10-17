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
    
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    
    @State private var coins: Int       = 100
    @State private var betAmount: Int   = 10
    @State private var reels: Array     = [0, 1, 2]
    
    @State private var showingInfoView: Bool    = false
    @State private var isActiveBet10: Bool      = true
    @State private var showingModal: Bool       = false
    @State private var animatingSymbol: Bool    = false
    @State private var animatingModal: Bool     = false
    
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
    func checkGameOver() {
        if coins <= 0 {
            // SHOW MODAL WINDOW
            showingModal = true
        }
    }
    
    // MARK: - SUB FUNCTIONS
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighscore() {
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "HighScore")
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
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activateBet10()
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
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                            })
                    } // ZStack Reel #1
                    
                    HStack(alignment: .center, spacing: 0) {
                        // REEL #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.8...0.9)))
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                        
                        Spacer()
                        
                        // REEL #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                    } // HStack Reel #2 & #3
                    .frame(maxWidth: 500)
                    
                    // MARK: - SPIN BUTTON
                    Button(action: {
                        // 1. SET THE DEFAULT STATE: NO ANIMATION
                        withAnimation {
                            self.animatingSymbol = false
                        }
                        
                        // 2. SET THE REELS WITH CHANGING THE SYMBOLS
                        self.spinReels()
                        
                        // 3. TRIGGER THE ANIMATION AFTER CHANGING THE SYMBOLS
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        
                        // 4. CHECK WINNING
                        self.checkWinning()
                        
                        // 5. GAME IS OVER
                        self.checkGameOver()
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
                            .offset(x: isActiveBet10 ? 20 : 0)
                            .opacity(isActiveBet10 ? 0 : 1)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    Spacer()
                    
                    // BET 10
                    HStack(alignment: .center, spacing: 10) {
                        Image(SMImageName.casinoChips)
                            .resizable()
                            .offset(x: isActiveBet10 ? 0 : -20)
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
                    self.resetGame()
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
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK: - POPUP
            if $showingModal.wrappedValue {
                ZStack {
                    SMColors.trBlack.edgesIgnoringSafeArea(.all)
                    
                    // MODAL
                    VStack(spacing: 0) {
                        // TITLE
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(SMColors.pink)
                            .foregroundColor(Color.white)
                        Spacer()
                        
                        // MESSAGE
                        VStack(alignment: .center, spacing: 16) {
                            Image(SMImageName.sevenReel)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal   = false
                                self.animatingModal = false
                                self.activateBet10()
                                self.coins = 100
                            }) {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(SMColors.pink)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(SMColors.pink)
                                    )
                            }
                        }
                        Spacer()
                    }.frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: SMColors.trBlack, radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModal = true
                    })
                }
            }
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
