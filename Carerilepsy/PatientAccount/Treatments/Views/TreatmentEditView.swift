//
//  TreatmentEditView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 18/07/2021.
//

import SwiftUI

enum Mode {
  case new
  case edit
}

enum Action {
  case delete
  case done
  case cancel
}

struct TreatmentDay: Identifiable, Encodable, Decodable {
    var id = UUID()
    var dayName: String
    var toggleValue: Bool
}

struct TreatmentEditView: View {
    
    let treatmentTypes: [String] = ["Medication", "Device", "Exercises", "Diet"]
    let intakeTypes: [String] = ["Pill", "Liquid", "Suppository", "Inhaler", "Injection"]
    let medicationUnits: [String] = ["mg", "ml", "g", "pill"]
    let otherUnits: [String] = ["minutes", "hours", "mA", "calories", "serving"]
    let daysOfWeek: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    // MARK: - State
    @Environment(\.presentationMode) var presentationMode
    @State var presentActionSheet = false
    @State var timeCount: Int = 1
    @State var selectedTimeIndex = 1
    
    
    // MARK: - State (Initialiser-modifiable)
    @StateObject var dateModel = DateViewModel()
    @StateObject var viewModel = TreatmentViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    @EnvironmentObject var notificationManager: NotificationManager
    
    
    // MARK: - UI Components
    var cancelButton: some View {
      Button(action: { self.handleCancelTapped() }) {
        Text("Cancel")
      }
    }
    
    var saveButton: some View {
        Button(action: {
            self.handleSaveTapped()
            
            if mode == .new {
    
                createLocalNotifications()
            }
            
            if mode == .edit {
                
                deleteLocalNotifications()
                createLocalNotifications()
            }
            
            
        }) {
            Text(mode == .new ? "Save" : "Update")
        }
        .disabled(!viewModel.modified)
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    
                    if mode == .new {
                        VStack(spacing: 10) {
                            Image(systemName: "cross.case.fill")
                                .foregroundColor(Color("Color"))
                                .font(.system(size: 30))
                                .padding(.top)
                            
                            Text("Treatment")
                                .font(.headline)
                        }
                    }
                    
                    
                    Form{
                        Section(header: Text("Info")){
                            
                            Picker("Type of treatment", selection: $viewModel.treatment.type) {
                                ForEach(treatmentTypes, id: \.self) {
                                    Text($0)
                                }
                            }
                            if viewModel.treatment.type == "Medication" {
                                Picker("Type of intake", selection: $viewModel.treatment.intake) {
                                    ForEach(intakeTypes, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                            
                            TextField("Name of treatment", text: $viewModel.treatment.name)
                            
                            HStack {
                                
                                TextField("Dosage", text: $viewModel.treatment.dosage)
                                    
                                Divider()
                                Spacer()
                                
                                Picker("Unit", selection: $viewModel.treatment.dosageUnit) {
                                    ForEach(viewModel.treatment.type == "Medication" ? medicationUnits : otherUnits, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                        }
                        
                        Section(header: Text("Frequency")){
                            
                            VStack(spacing: 5){
                                
                                ForEach(1...timeCount, id: \.self){ index in
                                    HStack{
                                        
                                        Text("Time \(index):")
                                        
                                        Spacer()
                                        
                                        Text(viewModel.treatment.time[index - 1], style: .time)
                                            .onTapGesture {
                                                self.selectedTimeIndex = index
                                                // setting time as previous selection
                                                dateModel.setTime(date: viewModel.treatment.time[index - 1])
                                                withAnimation(.spring()){
                                                    dateModel.showPicker.toggle()
                                                }
                                            }
                                        
                                        
                                        Spacer()
                                    }
                                }
                                .padding(.top, 7)
                                
                                
                                
                                Button(action: {
                                    self.timeCount += 1
                                    viewModel.treatment.time.append(dateModel.selectedDate)
                                }) {
                                    Text("+ Add time")
                                        .foregroundColor(Color("Color"))
                                        .padding(.vertical, 10)
                                        .frame(width: UIScreen.main.bounds.width - 80)
                                        .background(Color(#colorLiteral(red: 0.9137254902, green: 0.9411764706, blue: 1, alpha: 1)).opacity(0.9))
                                        .cornerRadius(10)
                                        .padding(.vertical, 7)
                                }
                                

                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            DatePicker("Start date:", selection: $viewModel.treatment.startDate, in: Date()..., displayedComponents: .date)
                            
                            Picker(
                                selection: $viewModel.treatment.daily,
                                label: Text("Picker"),
                                content: {
                                    Text("Daily")
                                        .tag(true)
                                    Text("Select Days")
                                        .tag(false)
                                    
                            })
                            .pickerStyle(SegmentedPickerStyle())
                            
                            
                            
                            if viewModel.treatment.daily == false {
                                ForEach(daysOfWeek.indices) { index in
                                    Toggle("\(daysOfWeek[index])", isOn: $viewModel.treatment.days[index].toggleValue)
                                        .toggleStyle(SwitchToggleStyle(tint: Color("Color").opacity(0.5)))
                                }
                            }
                            

                        }
                        
                        Section(header: Text("Additonal Details")){
                            TextEditor(text:  $viewModel.treatment.comment).lineLimit(4)
                        }
                        
                        if mode == .edit {
                            Section {
                                Button("Delete treatment") { self.presentActionSheet.toggle() }
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .navigationTitle(mode == .new ? "New treatment" : viewModel.treatment.name)
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
                                                        deleteLocalNotifications()
                                                     }),
                                        .cancel()
                                    ])
                    }
                }
                .onAppear(perform: {
                    
                    if mode == .edit {
                        self.timeCount = viewModel.treatment.time.count
                    }
                    
                    // setting accent color
                    
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("Color"))
                    
                    let attributes: [NSAttributedString.Key:Any] = [
                        .foregroundColor: UIColor.white
                    ]
                    UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
                })
                
                ClockView(index: selectedTimeIndex)
                    .environmentObject(dateModel)
                    .environmentObject(viewModel)
                
            }
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
    
    func createLocalNotifications() {
        
        // formmatting date object
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        for index in viewModel.treatment.time.indices {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: viewModel.treatment.time[index])
            guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return }
            
            // creating daily local notification
            if viewModel.treatment.daily {
                notificationManager.createLocalNotificationDaily(uuid: "\(viewModel.treatment.id!)_\(index)", title: "Treatment Reminder", subtitle: "\(viewModel.treatment.type) - \(viewModel.treatment.name)", body: "time to take your treatment, scheduled for \(formatter.string(from: viewModel.treatment.time[index]))", hour: (hour), minute: minute) { error in
                    if error == nil {
                        print("notication reminder #\(index) has been set")
                        notificationManager.listScheduledNotifications()
                    }
                }
            }
            // creating local notifications for selected days of the week
            else if !viewModel.treatment.daily {
                for day in viewModel.treatment.days {
                    if day.toggleValue {
                        notificationManager.createLocalNotification(uuid: "\(viewModel.treatment.id!)_\(index)_\(day.dayName)", title: "Treatment Reminder", subtitle: "\(viewModel.treatment.type) - \(viewModel.treatment.name)", body: "time to take your treatment, scheduled for \(formatter.string(from: viewModel.treatment.time[index]))", hour: (hour), minute: minute, weekday: getWeekdayInt(dayOfWeek: day.dayName)) { error in
                            if error == nil {
                                print("notication reminder #\(index)_\(day.dayName) has been set")
                            }
                        }
                    }
                }
            }
            
        }
        
        notificationManager.listScheduledNotifications()
    }

    
    func deleteLocalNotifications() {
        
        var identifiers: [String] = []
        
        
        if viewModel.treatment.daily {
            for index in viewModel.treatment.time.indices {
                identifiers.append("\(viewModel.treatment.id!)_\(index)")
            }
        }
        else if !viewModel.treatment.daily {
            for index in viewModel.treatment.time.indices {
                for day in viewModel.treatment.days {
                    identifiers.append("\(viewModel.treatment.id!)_\(index)_\(day.dayName)")
                }
            }
        }
        
        notificationManager.deleteLocalNotifications(identifiers: identifiers)
        print("notifications deleted")
    }
    
    
    func getWeekdayInt(dayOfWeek: String) -> Int {
        switch dayOfWeek {
        case "Mon":
            return 2
        case "Tue":
            return 3
        case "Wed":
            return 4
        case "Thu":
            return 5
        case "Fri":
            return 6
        case "Sat":
            return 7
        case "Sun":
            return 1
        default:
            print("dayOfWeek doesn't match any valid cases")
            return 0
        }
    }
    
    

}

struct TreatmentEditView_Previews: PreviewProvider {
    
    static var previews: some View {
        TreatmentEditView()
    }
}
