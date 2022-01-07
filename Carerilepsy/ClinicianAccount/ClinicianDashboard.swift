//
//  ClinicianDashboard.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 03/08/2021.
//

import SwiftUI

struct ClinicianDashboard: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().barTintColor = UIColor(named: "Secondary")
    }
    
    @StateObject var listViewModel = PatientsViewModel()
    
    var body: some View {
        
        TabView{
            NavigationView{
                DataDashboardView()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Dashboard")
            }
            
            NavigationView{
                PatientsListView()
                    .navigationTitle("Patients")
            }
            .tabItem {
                Image(systemName: "person.3")
                Text("Patients")
            }
            
            NavigationView{
                SettingsView(profile: .clinician)
                    .navigationTitle("Profile")
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            
        }
        .accentColor(Color("Color"))
        .environmentObject(self.listViewModel)
        
    
    }
}

struct ClinicianDashboard_Previews: PreviewProvider {
    static var previews: some View {
        ClinicianDashboard()
    }
}
