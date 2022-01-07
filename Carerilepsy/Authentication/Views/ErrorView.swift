//
//  ErrorView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 10/07/2021.
//

import SwiftUI

struct ErrorView: View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert: Bool
    @Binding var error: String
    
    var body: some View {
        
        GeometryReader{ geo in
            
            VStack {
                
                HStack {
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                }
                .padding(.horizontal, 25)
                
                
                Text(self.error == "RESET" ? "Password reset email sent." : self.error)
                    .foregroundColor(self.color)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: { self.alert.toggle() }) {
                    Text(self.error == "RESET" ? "OK" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
            
        }
        .background(Color.black.opacity(0.35).ignoresSafeArea(.all))
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(alert: .constant(false), error: .constant(""))
    }
}
