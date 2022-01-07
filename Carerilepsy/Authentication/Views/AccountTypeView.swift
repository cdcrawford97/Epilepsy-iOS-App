//
//  CreateProfileView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 20/07/2021.
//

import SwiftUI

struct AccountTypeView: View {
    
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                Text("Please select an account type before using the app")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .padding(.bottom, 30)
                
                
                NavigationLink(destination: CreateProfileView() ) {
                    
                    Text("Create Patient Account")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color("Color"))
                        .cornerRadius(10)
                }
                
                HStack (spacing: 10){
                    Image(systemName: "info.circle")
                        .font(.system(size: 15))
                    Text("Log seizures, treatments and set alerts")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .padding(.top, 5)
                
                NavigationLink(destination: CreateProfileView(profile: .clinician) ) {
                    
                    Text("Create Clinician Account")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color("Color"))
                        .cornerRadius(10)
                    
                }
                
                
                HStack (spacing: 10){
                    Image(systemName: "info.circle")
                        .font(.system(size: 15))
                    Text("Monitor patient data via dashboard analytics")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Spacer()
                
            }
            .padding()
            
        }
        
    }
}

struct AccountTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTypeView()
    }
}
