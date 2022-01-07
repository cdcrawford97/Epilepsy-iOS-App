//
//  SideMenuView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 08/08/2021.
//

import SwiftUI

struct SideMenuView: View {
    
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack{
            // Dimmed background view
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.15))
            .opacity(self.menuOpened ? 1 : 0)
            .animation(Animation.easeIn.delay(0.15))
            .onTapGesture {
                self.toggleMenu()
            }
            
            // MenuContent
            HStack {
                MenuContent(toggleMenu: toggleMenu)
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default)
                
                Spacer()
            }
            
        }
    }
}


