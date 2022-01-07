//
//  ContentView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 10/07/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @StateObject private var session = SessionAuth()
    @State private var isLoading = false
    @AppStorage("isOnboarding") private var isOnboarding = true
    
    func listen() {
        session.listenAuthentificationState()
    }
    
    func loadingScreen() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            isLoading = false
        }
    }
        
    var body: some View {
            
        ZStack {
            VStack {
                if session.isLoggedIn {
                    if session.isPatientProfileCreated {
                        PatientDashboard()
                            .onAppear(perform: loadingScreen)
                    }
                    else if session.isClinicianProfileCreated {
                        ClinicianDashboard()
                            .onAppear(perform: loadingScreen)
                    }
                    else {
                        AccountTypeView()
                    }
                }
                else {
                    WelcomeView()
                }
            }
            
            if isLoading {
                LoadingView()
            }
            
            if isOnboarding {
                Onboarding()
            }
            
        }
        .onAppear(perform: loadingScreen)
        .onAppear(perform: listen)
        .environmentObject(self.session)
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color("Color")))
                .scaleEffect(1.7)
        }
    }
}
