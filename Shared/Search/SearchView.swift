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
                .padding(.vertical)
                .opacity(showSearch ? 1 : 0)
                .scaleEffect(CGSize(width: showSearch ? 1 : 1.4, height: showSearch ? 1 : 1.7))
                .offset(x: 0, y: showSearch ? 0 : 50)
                
                SearchResultList(searchResultList: $searchLogic.searchResultList, showSearch: $showSearch)
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

struct SearchResultList: View {
    @Binding var searchResultList: [SearchResult]
    @Binding var showSearch: Bool
    
    var body: some View {
        ForEach(searchResultList) { result in
            VStack {
                HStack(spacing: 8) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(result.symbolSearch.symbol)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            
                            Color(.black).opacity(0.75)
                                .frame(width: 1)
                            
                            Text(result.symbolSearch.exchangeShortName)
                                .font(.caption)
                        }
                        .frame(maxHeight: 22)
                        
                        Text(result.symbolSearch.name)
                            .lineLimit(2)
                            .frame(maxHeight: 44)
                    }
                    
                    Spacer()
                    
                    RightComponentView(marketInfo: result.marquetInfo)
                }
                
                Divider()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .onTapGesture(perform: {
                self.showSearch = false
            })
        }
    }
}
