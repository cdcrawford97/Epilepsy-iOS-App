//
//  Settings.swifr.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 13/07/2021.
//

import SwiftUI
import Firebase
import UserNotifications

enum profileType {
  case patient
  case clinician
}

struct SettingsView: View {
    
    var profile: profileType = .patient
    
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var cliniciansViewModel = CliniciansViewModel()
    @StateObject var clinicianViewModel = ClinicianViewModel()
    @StateObject var patientViewModel = PatientViewModel()
    
    // on delete state variables
    @State private var showingAlert = false
    @State private var deleteIndexSet: IndexSet?
    
    private func requestRowView(request: Clinician) -> some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(request.name)
                    .font(.headline)
                Text(request.email)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button(action: {
                
                // update clinician object for patient
                clinicianViewModel.clinician = request
                clinicianViewModel.clinician.status = "Accepted"
                clinicianViewModel.update()
                
                // create patient object for clinician
                patientViewModel.addPatient(clinician: request)
                
            }) {
                Text("Accept")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(Color.green)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                clinicianViewModel.clinician = request
                clinicianViewModel.clinician.status = "Rejected"
                clinicianViewModel.update()
            }) {
                Text("Reject")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(Color.red)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(.vertical)
    }
    
    private func linkedAccountRowView(clinician: Clinician) -> some View {
        
            VStack(alignment: .leading) {
                    Text(clinician.name)
                        .font(.headline)
                    Text(clinician.email)
                        .font(.subheadline)
            }

    }
    
    
    var body: some View {
        
        VStack {
            
            Form{
                
                Section(header: Text("Name")){
                    Text("\(profile == .patient ? viewModel.patientProfile.name : viewModel.clinicianProfile.name)")
                }
                
                if profile == .patient {
                    
                    Section(header: Text("Linked Clinician Accounts")){
                        List {
                            ForEach(cliniciansViewModel.clinicians) { clinician in
                                if clinician.status == "Accepted" {
                                    linkedAccountRowView(clinician: clinician)
                                }
                            }
                            .onDelete(perform: { indexSet in
                                self.showingAlert = true
                                self.deleteIndexSet = indexSet
                            })
                            
                            if cliniciansViewModel.clinicians.filter{$0.status == "Accepted"}.count == 0 {
                                VStack(alignment: .center) {
                                    Text("No actively linked clinician accounts")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Clinician Data Sharing Requests")){
                        List {
                            ForEach(cliniciansViewModel.clinicians) { request in
                                if request.status == "Pending" {
                                    requestRowView(request: request)
                                }
                            }
                            if cliniciansViewModel.clinicians.filter{$0.status == "Pending"}.count == 0 {
                                VStack(alignment: .center) {
                                    Text("No currently active requests")
                                }
                            }
                            
                        }
                    }
                }

                
                Section(header: Text("Info")){
                    Link("Terms of Service", destination: URL(string: "https://google.co.uk")!)
                }
                
                Section{
                    HStack {
                        Spacer()
                        Button(action: {
                            try! Auth.auth().signOut()
                        }) {
                            Text("Log out")
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
                }
            }
            .onAppear(){
                profile == .patient ? self.viewModel.fetchPatientProfileData() : self.viewModel.fetchClinicianProfileData()
                cliniciansViewModel.fetchData()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Confirm deletion"),
                message: Text("Are you sure you want to delete this clinician account from accessing your data?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        
                        let indexSet = self.deleteIndexSet!
                        
                        let clinicians = indexSet.map {
                            cliniciansViewModel.clinicians[$0]
                        }
                        // deletes clinician objects from patient
                        clinicianViewModel.removeClinicians(clinicians: clinicians)
                        
                        // deletes patient objects from clinicican
                        for clinician in clinicians {
                            patientViewModel.removePatient(clinician: clinician)
                        }
                        
                    }
                )
            )
        }
    }
}


struct SettingsView_swifr_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
