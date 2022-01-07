//
//  CreatePatientProfileView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 20/07/2021.
//

import SwiftUI

enum Profile {
  case patient
  case clinician
}

struct CreateProfileView: View {
    
    @State var color = Color.black.opacity(0.7)
    
    @StateObject var viewModel = ProfileViewModel()
    
    @EnvironmentObject var session: SessionAuth
    
    var profile: Profile = .patient
    
    var body: some View {
        
        
        VStack (spacing: 30){
            
            Text(profile == .patient ? "Create Patient Profile" : "Create Clinician Profile")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(self.color)
                .padding(.top, 35)
            
            Image(systemName: profile == .patient ? "person.crop.circle" : "stethoscope")
                .font(.system(size: 80))
            
            
            TextField("Name", text: (profile == .patient ? $viewModel.patientProfile.name : $viewModel.clinicianProfile.name) )
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(viewModel.patientProfile.name != "" || viewModel.clinicianProfile.name != "" ? Color("Color") : self.color, lineWidth: 2))

            Button(action: {
                profile == .patient ? viewModel.savePatient() : viewModel.saveClinician()
                if profile == .patient {
                    session.isPatientProfileCreated = true
                }
                else {
                    session.isClinicianProfileCreated = true
                }
            }) {
                Text("Create Profile")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
                        
            
            Spacer()
        }
        .padding(.horizontal, 25)
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView()
    }
}
