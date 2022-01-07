//
//  SeizureEditView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 01/08/2021.
//

import SwiftUI

enum SeizureMode {
  case new
  case edit
}

enum SeizureAction {
  case delete
  case done
  case cancel
}

struct SeizureEditView: View {
    
    let seizureOptions: [String] = ["Seizure", "Cluster"]
    let seizureTypes: [String] = ["Absence", "Atypical", "Atonic", "Automatisms", "Autonomic", "Clonic", "Cognitive", "Emotional", "Hyperkinetic", "Myoclonic of the eyelid", "Myoclonic", "Myoclonic-atonic", "Myoclonic-tonic-clonic", "Sensory", "Epileptic spasms", "Typical", "Tonic", "Tonic-clonic"]
    let seizureTriggers: [String] = ["Alcohol", "Bright lights", "Certain foods", "Excitement", "Fear", "Fever", "Forgot medicine", "Hunger", "Illness", "Lack of sleep", "Loss of balance", "Pain", "Patterns", "Period", "Sleep cycle", "Stress", "Too cold", "Too hot", "None", "Other"]
    let rescueMedications: [String] = ["Midazolam", "Diazapem", "Clobazam", "Vague nerve stimulation", "Other"]
    
    @State private var date = Date()
    
    // MARK: - State
    @Environment(\.presentationMode) var presentationMode
    @State var presentActionSheet = false
    
    
    
    // MARK: - State (Initialiser-modifiable)
    @StateObject var viewModel = SeizureViewModel()
    var mode: SeizureMode = .new
    var completionHandler: ((Result<SeizureAction, Error>) -> Void)?
    
    
    // MARK: - UI Components
    
    var cancelButton: some View {
      Button(action: { self.handleCancelTapped() }) {
        Text("Cancel")
      }
    }
    
    var saveButton: some View {
        Button(action: {
            self.handleSaveTapped()
        }) {
            Text(mode == .new ? "Save" : "Update")
        }
        .disabled(!viewModel.modified)
    }
    
    var body: some View {
        NavigationView{
            VStack {
                
                if mode == .new {
                    VStack(spacing: 10) {
                        Image(systemName: "bolt")
                            .foregroundColor(Color("Color"))
                            .font(.system(size: 30))
                            .padding(.top)
                        
                        Text("Seizure")
                            .font(.headline)
                    }
                }
                
                Form{
                    Section(header: Text("Info")){
                        
                        DatePicker("Date & time", selection: $viewModel.seizure.dateTime)
                        
                        Picker(
                            selection: $viewModel.seizure.clusterOrSeizure,
                            label: Text("Picker"),
                            content: {
                                ForEach(seizureOptions.indices) { index in
                                    Text(seizureOptions[index])
                                        .tag(seizureOptions[index])
                                }
                                
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if viewModel.seizure.clusterOrSeizure == "Cluster" {
                            Stepper("Number of seizures:   \(viewModel.seizure.numberOf)",value: $viewModel.seizure.numberOf, in: 1...10)
                        }
                        
                        Picker("Type of seizure", selection: $viewModel.seizure.type) {
                            ForEach(seizureTypes, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        Picker("Trigger", selection: $viewModel.seizure.trigger) {
                            ForEach(seizureTriggers, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        Picker("Rescue medication given", selection: $viewModel.seizure.rescueMed) {
                            ForEach(rescueMedications, id: \.self) {
                                Text($0)
                            }
                        }
                        
                    }
                    
                    Section(header: Text("Duration")){
                        Stepper("Minute(s):   \(viewModel.seizure.minutes)",value: $viewModel.seizure.minutes, in: 0...60)
                        Stepper("Second(s):   \(viewModel.seizure.seconds)",value: $viewModel.seizure.seconds, in: 0...60)
                    }
                    
                    Section(header: Text("Remarks")){
                        TextEditor(text: $viewModel.seizure.remarks).lineLimit(4)
                    }
                    
                    if mode == .edit {
                        Section {
                            Button("Delete seizure") { self.presentActionSheet.toggle() }
                                .foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle(mode == .new ? "New seizure" : "Edit seizure")
                .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        cancelButton
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        saveButton
                    }
                }
                .actionSheet(isPresented: $presentActionSheet) {
                    ActionSheet(title: Text("Are you sure?"),
                                buttons: [
                                    .destructive(Text("Delete treatment"),
                                                 action: {
                                                    self.handleDeleteTapped()
                                                 }),
                                    .cancel()
                                ])
                }
            }
            .onAppear(perform: {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("Color"))
                
                let attributes: [NSAttributedString.Key:Any] = [
                    .foregroundColor: UIColor.white
                ]
                UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
            })
        }
        
    }
    
    
    // MARK: - Action Handlers
    
    func handleCancelTapped() {
        dismiss()
    }
    
    func handleSaveTapped() {
        viewModel.save()
        dismiss()
    }
    
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct SeizureEditView_Previews: PreviewProvider {
    static var previews: some View {
        SeizureEditView()
    }
}
