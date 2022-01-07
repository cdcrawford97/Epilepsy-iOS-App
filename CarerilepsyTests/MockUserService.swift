
//  MockUserService.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 02/09/2021.
//

@testable import Carerilepsy

final class MockUserService: UserServiceProtocol {
    
    var loginResult: Result<Void, Error> = .success(())
    var resetPasswordResult: Result<Void, Error> = .success(())
    var registerResult: Result<Void, Error> = .success(())
    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(loginResult)
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(resetPasswordResult)
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(registerResult)
    }
    
}

