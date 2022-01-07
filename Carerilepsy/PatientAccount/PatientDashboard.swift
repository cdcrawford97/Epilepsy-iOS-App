//
//  Dashboard.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 13/07/2021.
//

import SwiftUI

struct PatientDashboard: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().barTintColor = UIColor(named: "Secondary")
    }
    
    var body: some View {
        
        TabView{
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            NavigationView{
                SeizuresListView(dateRange: Date().startOfMonth()..<Date().endOfMonth())
                    .navigationTitle("Seizures")
            }
            .tabItem {
                Image(systemName: "bolt")
                Text("Seizures")
            }
            
            NavigationView{
                TreatmentsListView()
                    .navigationTitle("Treatments")
            }
            .tabItem {
                Image(systemName: "pills")
                Text("Treatments")
            }
            
            NavigationView{
                SettingsView()
                    .navigationTitle("Profile")
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            
        }
        .accentColor(Color(#colorLiteral(red: 0.368627451, green: 0.3764705882, blue: 0.6039215686, alpha: 1)))
        
    
    }
}

struct PatientDashboard_Previews: PreviewProvider {
    static var previews: some View {
        PatientDashboard()
    }
}
