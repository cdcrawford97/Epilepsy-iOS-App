//
//  AuthenticationViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 19/07/2021.
//

import Foundation
import Firebase

class SignUpViewModel: ObservableObject {
    
    @Published var user: SignUp
    @Published var registerSucess = false
    private let userService: UserServiceProtocol
    
    // initialize User object
    init(user: SignUp = SignUp(email: "", password: "", retypePassword: "", error: "", alert: false), userService: UserServiceProtocol = UserService()){
        self.user = user
        self.userService = userService
    }
    
    // authorisation of account creation
    func register(){
        
        if user.email != "" {
            if user.password == user.retypePassword {
                
                userService.register(email: user.email, password: user.password) { result in
                    
                    switch result {
                        case .success:
                            print("sucessfully registered account")
                            self.registerSucess = true
                        case let .failure(error):
                            self.user.error = error.localizedDescription
                            self.user.alert.toggle()
                    }
                }
                
            }
            else {
                user.error = "Passwords do not match"
                user.alert.toggle()
            }
        }
        else {
            user.error = "Please complete all fields"
            user.alert.toggle()
        }
        
    }
    
    
}
