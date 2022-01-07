//
//  Login.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 10/07/2021.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var visible = false
    
    @StateObject var viewModel = LoginViewModel()
    

    var body: some View {
    
        ZStack {
        
            VStack {
                
                Text("Log in to your account")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(self.color)
                    .padding(.top, 35)
                
                TextField("Email", text: $viewModel.user.email)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(viewModel.user.email != "" ? Color("Color") : self.color, lineWidth: 2))
                    .padding(.top, 25)
                
                
                HStack (spacing: 15) {
                    
                    VStack{
                        if self.visible {
                            TextField("Password", text: $viewModel.user.password)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Password", text: $viewModel.user.password)
                                .autocapitalization(.none)
                        }
                    }
                    
                    Button(action: { self.visible.toggle() }) {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(self.color)
                    }
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(viewModel.user.password != "" ? Color("Color") : self.color, lineWidth: 2))
                .padding(.top, 25)
                
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: { viewModel.resetPassword() }) {
                        Text("Forgot Password?")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color"))
                    }
                }
                .padding(.top, 20)
                
                Button(action: { viewModel.verify() }) {
                    Text("Log in")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
                Spacer()
                
                
            }
            .padding(.horizontal, 25)
            .onTapGesture {
                hideKeyboard()
            }
            
            if viewModel.user.alert {
                ErrorView(alert: $viewModel.user.alert, error: $viewModel.user.error)
            }
            
        }



    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
