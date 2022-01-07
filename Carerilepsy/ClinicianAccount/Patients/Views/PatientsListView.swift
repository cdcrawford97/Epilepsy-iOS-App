//
//  PatientsListView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 03/08/2021.
//

import SwiftUI
import MessageUI


struct PatientsListView: View {
    
    @StateObject var clinicianViewModel = ClinicianViewModel()
    @EnvironmentObject var listViewModel: PatientsViewModel
    @StateObject var patientViewModel = PatientViewModel()
    
    // on delete state variables
    @State private var showingAlert = false
    @State private var deleteIndexSet: IndexSet?
    
    // MARK: - UI Components
    private var addPatientButton: some View {
        Button(action: {
            alertView()
        }) {
            HStack {
                Text("Add Patient")
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }
        }
    }
    
    private func patientRowView(patient: Patient) -> some View {
        HStack {
            VStack(alignment: .leading){
                Text(patient.name)
                    .font(.headline)
                Text(patient.email)
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: "envelope")
                .imageScale(.large)
                .padding(.trailing, 20)
                .onTapGesture {
                    EmailHelper.shared.send(subject: "Message from your neurologist", body: "Hello \(patient.name),", to: [patient.email])
                }
        }
        .padding()
    }
    
    
    var body: some View {
        VStack {
            List {
                ForEach (listViewModel.patients) { patient in
                    patientRowView(patient: patient)
                }
                .onDelete(perform: { indexSet in
                    self.showingAlert = true
                    self.deleteIndexSet = indexSet
                })
                if listViewModel.patients.count == 0 {
                    Group { Text("Please add a new patient using the ") + Text("Add").bold().foregroundColor(Color("Color")) + Text(" button above.") }
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .listStyle(PlainListStyle())
            
            // patient deletion alert
            Text("")
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Confirm deletion"),
                        message: Text("Are you sure you want to delete this patient?"),
                        primaryButton: .cancel(),
                        secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                
                                let indexSet = self.deleteIndexSet!
                                
                                let patients = indexSet.map {
                                    listViewModel.patients[$0]
                                }
                                
                                // deletes patient objects from clinician
                                patientViewModel.removePatients(patients: patients)
                                
                                // deletes clincian objects from patient
                                for patient in patients {
                                    clinicianViewModel.removeClinician(patient: patient)
                                }
                                
                            }
                        )
                    )
                }
                .frame(width:0, height:0)
            
            
            // patient invite result alert
            Text("")
                .alert(isPresented: $clinicianViewModel.showAlert) {
                    switch clinicianViewModel.activeAlert {
                    case .success:
                        return Alert(title: Text("Success!"), message: Text("Invitation sucessfully sent to patient account."), dismissButton: .default(Text("OK")))
                    case .failure:
                        return Alert(title: Text("Failed"), message: Text("Email entered does not match an existing patient account."), dismissButton: .default(Text("OK")))
                    }
                }
                .frame(width:0, height:0)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addPatientButton
            }
        }
        .onAppear() {
            listViewModel.fetchData()
        }
    }
    
    func alertView() {
        let alert = UIAlertController(title: "Adding a Patient", message: "Please insert the email of the Patient", preferredStyle: .alert)
        
        alert.addTextField() { (email) in
            email.placeholder = "Email"
        }
        
        let invite = UIAlertAction(title: "Invite", style: .default) { (_) in
            let email = alert.textFields![0].text!
            clinicianViewModel.email = email
            clinicianViewModel.save()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            // actions
        }
        
        // adding into alert view
        alert.addAction(cancel)
        alert.addAction(invite)
        
        //presenting alert view
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            // actions
        })
        
    }
}

struct PatientsListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientsListView()
    }
}
