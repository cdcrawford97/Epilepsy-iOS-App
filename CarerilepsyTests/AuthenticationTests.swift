//
//  AuthenticationTests.swift
//  CarerilepsyTests
//
//  Created by Cameron Crawford on 31/08/2021.
//

import XCTest
@testable import Carerilepsy

class AuthenticationTests: XCTestCase {
    
    var loginViewModel: LoginViewModel!
    var registerViewModel: SignUpViewModel!
    var mockUserService: MockUserService!

    override func setUp() {
        mockUserService = MockUserService()
        loginViewModel = .init(userService: mockUserService)
        registerViewModel = .init(userService: mockUserService)
    }
    
    override func tearDownWithError() throws {
        loginViewModel = nil
        registerViewModel = nil
    }

    //MARK: Login Tests
    
    func testLoginWithCorrectDetailsSetLoginSuccessToTrue() {
        loginViewModel.user.email = "example@gmail.com"
        loginViewModel.user.password = "password"
        mockUserService.loginResult = .success(())
        loginViewModel.verify()
        XCTAssertTrue(loginViewModel.loginSucess)
    }
    
    func testLoginWithErrorSetsError() {
        loginViewModel.user.email = "example@gmail.com"
        loginViewModel.user.password = "password"
        mockUserService.loginResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        loginViewModel.verify()
        XCTAssertNotNil(loginViewModel.user.error)
        XCTAssertTrue(loginViewModel.user.alert)
    }
    
    func testLoginWithFieldsEmpty() {
        loginViewModel.verify()
        XCTAssertEqual(loginViewModel.user.error, "Please fill in all the required fields")
        XCTAssertTrue(loginViewModel.user.alert)
    }
    
    //MARK: Reset Email
    
    func testResetPasswordWithEmailEntered() {
        loginViewModel.user.email = "example@gmail.com"
        mockUserService.resetPasswordResult = .success(())
        loginViewModel.resetPassword()
        XCTAssertEqual(loginViewModel.user.error, "RESET")
        XCTAssertTrue(loginViewModel.user.alert)
    }
    
    func testResetPasswordWithNoEmailEntered() {
        loginViewModel.user.email = ""
        mockUserService.resetPasswordResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        loginViewModel.resetPassword()
        XCTAssertNotNil(loginViewModel.user.error)
        XCTAssertTrue(loginViewModel.user.alert)
    }
    
    func testEmailResetWithEmptyEmail() {
        loginViewModel.resetPassword()
        XCTAssertEqual(loginViewModel.user.error, "Please enter your email address to reset password")
        XCTAssertTrue(loginViewModel.user.alert)
    }
    
    //MARK: Registration Tests
    
    func testRegisterWithCorrectDetailsSetRegisterSuccessToTrue() {
        registerViewModel.user.email = "example@gmail.com"
        registerViewModel.user.password = "password"
        registerViewModel.user.retypePassword = "password"
        mockUserService.registerResult = .success(())
        registerViewModel.register()
        XCTAssertTrue(registerViewModel.registerSucess)
    }
    
    func testRegisterWithErrorSetsError() {
        registerViewModel.user.email = "example@gmail.com"
        registerViewModel.user.password = "password"
        registerViewModel.user.retypePassword = "password"
        mockUserService.registerResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        registerViewModel.register()
        XCTAssertNotNil(registerViewModel.user.error)
        XCTAssertTrue(registerViewModel.user.alert)
    }
    
    func testRegisterWithFieldsEmpty() {
        registerViewModel.register()
        XCTAssertEqual(registerViewModel.user.error, "Please complete all fields")
        XCTAssertTrue(registerViewModel.user.alert)
    }
    
    func testRegisterWithDifferentPasswords() {
        registerViewModel.user.email = "email@gmail.com"
        registerViewModel.user.password = "1"
        registerViewModel.user.retypePassword = "2"
        registerViewModel.register()
        XCTAssertEqual(registerViewModel.user.error, "Passwords do not match")
        XCTAssertTrue(registerViewModel.user.alert)
    }


}
