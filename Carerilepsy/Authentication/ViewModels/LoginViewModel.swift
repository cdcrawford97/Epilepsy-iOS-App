//
//  LoginModelView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 19/07/2021.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    
    @Published var user: Login
    @Published var loginSucess = false
    private let userService: UserServiceProtocol
    
    // initialize User object
    init(user: Login = Login(email: "", password: "", error: "", alert: false), userService: UserServiceProtocol = UserService()){
        self.user = user
        self.userService = userService
    }
    
    // Authorisation of login details
    func verify(){
        
        if user.email != "" && user.password != "" {
            
            userService.login(email: user.email, password: user.password) { result in
                
                switch result {
                    case .success:
                        print("logged in")
                        self.loginSucess = true
                    case let .failure(error):
                        self.user.error = error.localizedDescription
                        self.user.alert.toggle()
                }

            }
            
        } else {
            user.error = "Please fill in all the required fields"
            user.alert.toggle()
        }
        
    }
    
    
    // Reset Password function
    func resetPassword(){
        
        if user.email != ""{
            
            userService.resetPassword(email: user.email) { result in
                
                switch result {
                    case .success:
                        self.user.error = "RESET"
                        self.user.alert.toggle()
                    case let .failure(error):
                        self.user.error = error.localizedDescription
                        self.user.alert.toggle()
                }
            }
        }
        else {
            
            user.error = "Please enter your email address to reset password"
            user.alert.toggle()
            
        }
    }
    
    
    
}
