//
//  SearchBar.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/19/23.
//

import Foundation
import SwiftUI

// Customizable SearchBar
struct SearchBar: UIViewRepresentable {
    @State var initialText: String
    @Binding var text: String
    var onSearchButtonChanged: (() -> Void)? = nil
    
    class Coordinator: NSObject, UISearchBarDelegate {
        let searchBarView: SearchBar
        init(_ searchBar: SearchBar) {
            self.searchBarView = searchBar
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchBarView.text = searchText
            searchBarView.onSearchButtonChanged?()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBarView.onSearchButtonChanged?()
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = initialText
        searchBar.delegate = context.coordinator
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = self.text
    }
        
}
