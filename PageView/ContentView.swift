//
//  ContentView.swift
//  PageView
//
//  Created by Semih Cihan on 12.07.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Color.red
            
            Spacer()
            
            PageView(spacing: 40, peekWidth: 60, pageCount: 3) {
                Color(.black)
                    .frame(height: 40)
                Color(.yellow)
                    .frame(height: 40)
                Color(.red)
                    .frame(height: 40)
            }
            .background(.green)
            
            Spacer()
            Color.red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
