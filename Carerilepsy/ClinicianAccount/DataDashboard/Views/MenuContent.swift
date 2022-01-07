//
//  MenuContent.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 08/08/2021.
//

import SwiftUI

struct MenuContent: View {
    
    @EnvironmentObject var listViewModel: PatientsViewModel
    let toggleMenu: () -> Void
    @EnvironmentObject var selectedPatient: SelectedPatient
    
    var body: some View {
        
        ZStack {
            Color(.white)
            
            ScrollView(.vertical,showsIndicators: false){
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(listViewModel.patients) { patientIn in
                        
                        HStack{
                            Text(patientIn.name)
                                .bold()
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color("Color"))
                            
                            Spacer()
                        }
                        .padding()
                        .onTapGesture {
                            self.toggleMenu()
                            self.selectedPatient.patient = patientIn
                        }
                        
                        Divider()
                    }
                    
                    Spacer()
                    
                    if listViewModel.patients.count == 0 {
                        Text("No patients currently linked to this account.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding(.top, 15)
            }
            
        }
        .onAppear() {
            listViewModel.fetchData()
        }
    }
}

