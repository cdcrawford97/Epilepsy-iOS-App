//
//  SignUp.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 10/07/2021.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var visible = false
    @State var retypeVisible = false
    
    @StateObject var viewModel = SignUpViewModel()
    
    @EnvironmentObject var session: SessionAuth
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Text("Create an account")
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
                
                HStack (spacing: 15) {
                    
                    VStack{
                        if self.retypeVisible {
                            TextField("Confirm Password", text: $viewModel.user.retypePassword)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Confirm Password", text: $viewModel.user.retypePassword)
                                .autocapitalization(.none)
                        }
                    }
                    
                    Button(action: { self.retypeVisible.toggle() }) {
                        Image(systemName: self.retypeVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(self.color)
                    }
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(viewModel.user.retypePassword != "" ? Color("Color") : self.color, lineWidth: 2))
                .padding(.top, 25)

                
                Button(action: {
                    viewModel.register()
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
                
                
                HStack(spacing: 8) {
                    Text("Already have an account?")
                        .foregroundColor(Color.black.opacity(0.5))
                    NavigationLink(destination: LoginView() ){
                        Text("Sign In")
                            .foregroundColor(.blue)
                    }
                }
                .font(.body)
                .padding(.top, 10)
                    
                
                
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


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
