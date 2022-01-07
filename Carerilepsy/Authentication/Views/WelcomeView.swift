//
//  Welcome.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 11/07/2021.
//

import SwiftUI

struct WelcomeView: View {
    
    
    var body: some View {
        
        VStack{
                NavigationView{
                    VStack(spacing: 30){

                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.vertical, -100)
                        
                        
                        Text("Welcome to Carerilepsy")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color("Color"))
                            .padding(.top, 50)
                        
                        Text("Track seizures and treatments with seamless sharing of data")
                            .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: SignUpView() ) {
                            
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                                .background(Color("Color"))
                                .cornerRadius(10)
                        }

                        HStack(spacing: 8) {
                            Text("Already have an account?")
                                .foregroundColor(Color.black.opacity(0.5))
                            NavigationLink(destination: LoginView() ){
                                Text("Sign In")
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.body)
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }

    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
