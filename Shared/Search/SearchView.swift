//
//  SearchView.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 21/10/2020.
//

import SwiftUI

struct SearchView: View {
    @Binding var showSearch: Bool {
        didSet {
            self.searchLogic.resetValue()
        }
    }
    
    @ObservedObject var searchLogic = SearchLogic()
    
    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .frame(maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(showSearch ? 1 : 0)
            
            VStack {
                HStack(spacing: 20) {
                    TextField("Search", text: $searchLogic.userQuery)
                        .introspectTextField { textField in
                            if showSearch {
                                textField.becomeFirstResponder()
                            } else {
                                textField.resignFirstResponder()
                            }
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.white).opacity(0.5))
                        .padding(.leading, 20)
                    
                    
                    Button(action: {
                        showSearch.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                        
                    })
                    .buttonStyle(SearchButtonStyle())
                    .padding(.trailing, 20)
                }
                .padding(.top)
                .opacity(showSearch ? 1 : 0)
                .scaleEffect(CGSize(width: showSearch ? 1 : 1.4, height: showSearch ? 1 : 1.7))
                .offset(x: 0, y: showSearch ? 0 : 50)
                
                ForEach(searchLogic.searchSymbolList) { searchSymbol in
                    HStack {
                        Text(searchSymbol.name)
                            .padding()
                        
                        Text(searchSymbol.exchangeShortName)
                    }
                }
                .opacity(showSearch ? 1 : 0)
                .scaleEffect(CGSize(width: showSearch ? 1 : 1.4, height: showSearch ? 1 : 1.25))
                .offset(x: 0, y: showSearch ? 0 : 50)
                .animation(.easeOut(duration: 0.14))
                
                Spacer()
            }
            
        }
        .animation(.easeInOut)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(showSearch: .constant(true))
    }
}
