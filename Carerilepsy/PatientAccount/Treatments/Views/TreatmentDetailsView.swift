//
//  TreatmentDetailsView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 18/07/2021.
//

import SwiftUI

struct TreatmentDetailsView: View {
    
    // MARK: - State
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var notificationManager: NotificationManager
    @State var presentEditTreatmentSheet = false
    
    var treatment: Treatment
    
    var body: some View {
        
        
        VStack(spacing: 10) {

            Form{
                Section(header: Text("Info")){
                    HStack {
                        Text("Type of treatment")
                        Spacer()
                        Text(treatment.type)
                    }
                    HStack {
                        Text("Name of treatment")
                        Spacer()
                        Text(treatment.name)
                    }
                    if treatment.intake != ""{
                        HStack {
                            Text("Type of intake")
                            Spacer()
                            Text(treatment.intake)
                        }
                    }
                    HStack {
                        Text("Dosage")
                        Spacer()
                        Text(treatment.dosage + " " + treatment.dosageUnit)
                    }
                }
                Section(header: Text("Frequency")){
                    ForEach(0..<treatment.time.count, id: \.self){ index in
                        HStack {
                            Text("Time \(index + 1):")
                            Spacer()
                            Text(treatment.time[index], style: .time)
                        }
                    }
                    HStack {
                        Text("Start date")
                        Spacer()
                        Text(treatment.startDate, style: .date)
                    }
                    HStack {
                        Text("Repeat")
                        Spacer()
                        if treatment.daily {
                            Text("Daily")
                        }
                        else {
                            ForEach(treatment.days.indices, id: \.self) { index in
                                if treatment.days[index].toggleValue {
                                    Text("\(treatment.days[index].dayName)")
                                }
                            }
                        }
                    }
                }
                Section(header: Text("Additonal Details")){
                    Text(treatment.comment)
                }
            }
            .navigationBarTitle(treatment.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.presentEditTreatmentSheet.toggle() }) {
                      Text("Edit")
                    }
                }
            }
            .sheet(isPresented: self.$presentEditTreatmentSheet) {
                TreatmentEditView(viewModel: TreatmentViewModel(treatment: treatment), mode: .edit) { result in
                    if case .success(let action) = result, action == .delete {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .environmentObject(self.notificationManager)
                .accentColor(Color("Color"))
            }
        }
    }
}

struct TreatmentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let treatment = Treatment(type: "Changer", intake: "intake", name: "Matt Gemmell", dosage: "444", dosageUnit: "mg", time: [], startDate: Date(), daily: true, days: [TreatmentDay(dayName: "Mon", toggleValue: true)], comment: "hi")
        TreatmentDetailsView(treatment: treatment)
    }
}
