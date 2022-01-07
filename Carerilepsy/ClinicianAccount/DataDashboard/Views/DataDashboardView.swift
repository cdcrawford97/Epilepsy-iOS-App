//
//  DataDashboardView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 03/08/2021.
//

import SwiftUI

class SelectedPatient: ObservableObject {
    @Published var patient = Patient(id: "", name: "", email: "", uuid: "")
}

struct DataDashboardView: View {
    
    @State var menuOpened = false
    @StateObject var selectedPatient = SelectedPatient()
    
    
    var body: some View {
        ZStack{
            
            if !menuOpened && selectedPatient.patient.id == "" {
                Text("Please select a patient from the sidebar to view their data.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if selectedPatient.patient.id != "" {
                DataView(patient: self.selectedPatient.patient, dateRange: Date().startOfWeek()..<Date().endOfDay())
            }
            
            SideMenuView(width: UIScreen.main.bounds.width/1.6,
                         menuOpened: menuOpened,
                         toggleMenu: toggleMenu)
                .environmentObject(selectedPatient)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.menuOpened.toggle()
                } label: {
                    //label instead of image for accessibility reasons
                    Label("SideBar", systemImage: "sidebar.left")
                }
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "person")
                    Text(selectedPatient.patient.id == "" ? "Select a Patient" : selectedPatient.patient.name).font(.headline)
                }
            }
        }
    }
    
    func toggleMenu() {
        menuOpened.toggle()
    }
    
}

struct DataDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DataDashboardView()
    }
}
