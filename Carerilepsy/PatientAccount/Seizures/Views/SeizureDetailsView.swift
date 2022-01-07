//
//  SeizureDetailsView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 01/08/2021.
//

import SwiftUI

struct SeizureDetailsView: View {
    
    // MARK: - State
    
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditSeizureSheet = false
    
    // MARK: - State (via initialiser)
    
    var seizure: Seizure
    
    var body: some View {
        
        
        VStack(spacing: 10) {

            Form{
                Section(header: Text("Info")){
                    
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(seizure.dateTime, style: .date)
                    }
                    
                    HStack {
                        Text("Time")
                        Spacer()
                        Text(seizure.dateTime, style: .time)
                    }
                    
                    HStack {
                        Text("Type of seizure")
                        Spacer()
                        Text(seizure.type)
                    }
                    
                    if seizure.clusterOrSeizure == "Cluster" {
                        HStack {
                            Text("Number of seizures")
                            Spacer()
                            Text("\(seizure.numberOf)")
                        }
                    }
                    
                    HStack {
                        Text("Trigger")
                        Spacer()
                        Text(seizure.trigger)
                    }
                    
                    HStack {
                        Text("Rescue medication given")
                        Spacer()
                        Text(seizure.rescueMed)
                    }
                }
                
                Section(header: Text("Duration")){
                    HStack {
                        Text("Minute(s)")
                        Spacer()
                        Text("\(seizure.minutes)")
                    }
                    
                    HStack {
                        Text("Second(s)")
                        Spacer()
                        Text("\(seizure.seconds)")
                    }
                }

                Section(header: Text("Remarks")){
                    Text(seizure.remarks)
                }
            }
            .navigationBarTitle("Seizure details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.presentEditSeizureSheet.toggle() }) {
                      Text("Edit")
                    }
                }
            }
            .sheet(isPresented: self.$presentEditSeizureSheet) {
                SeizureEditView(viewModel: SeizureViewModel(seizure: seizure), mode: .edit) { result in
                    if case .success(let action) = result, action == .delete {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .accentColor(Color("Color"))
            }
        }
        .navigationBarTitle("")
    }
}

struct SeizureDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let seizure = Seizure(dateTime: Date(), numberOf: 1, clusterOrSeizure: "Seizure", type: "", minutes: 0, seconds: 0, trigger: "", rescueMed: "", remarks: "")
        SeizureDetailsView(seizure: seizure)
    }
}
