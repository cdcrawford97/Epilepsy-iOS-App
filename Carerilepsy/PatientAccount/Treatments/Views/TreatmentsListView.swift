//
//  TreatmentsList.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 19/07/2021.
//

import SwiftUI

struct TreatmentsListView: View {
    
    
    @StateObject var notificationManager = NotificationManager()
    
    // MARK: - State
    @Environment(\.presentationMode) var presentation
    @StateObject var viewModel = TreatmentsViewModel()
    @State var presentAddTreatmentSheet = false
    @State var showAuthAlert = false
    
    
    // MARK: - UI Components
  
    private var addButton: some View {
        Button(action: { self.presentAddTreatmentSheet.toggle() }) {
            HStack {
                Text("Add")
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }
        }
    }
  
    private func treatmentRowView(treatment: Treatment) -> some View {
        NavigationLink(destination: TreatmentDetailsView(treatment: treatment).environmentObject(self.notificationManager)) {
            HStack {
                Image("pills")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.trailing,10)
                
                VStack(alignment: .leading) {
                    Text(treatment.type)
                        .font(.headline)
                    Text(treatment.name)
                        .font(.subheadline)
                    Text(treatment.dosage + " " + treatment.dosageUnit)
                        .font(.subheadline)
                }
            }
        }
    }
    
    
    var body: some View {
        VStack{
            List {
                ForEach (viewModel.treatments) { treatment in
                    treatmentRowView(treatment: treatment)
                }
                if viewModel.treatments.count == 0 {
                    Group { Text("Please add a new treatment using the ") + Text("Add").bold().foregroundColor(Color("Color")) + Text(" button above.") }
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UITableView.selectionDidChangeNotification)) {
            guard let tableView = $0.object as? UITableView,
                  let selectedRow = tableView.indexPathForSelectedRow else { return }

            tableView.deselectRow(at: selectedRow, animated: true)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton
            }
        }
        .onAppear() {
            DispatchQueue.main.async {
                self.viewModel.fetchData()
            }
        }
        .sheet(isPresented: self.$presentAddTreatmentSheet) {
            TreatmentEditView()
                .environmentObject(self.notificationManager)
                .alert(isPresented: $showAuthAlert) {
                    Alert(
                        title: Text("Notification Access"),
                        message: Text("Please enable Notification Permission in Settings in order to recieve treatment reminders."),
                        primaryButton: .destructive(Text("Cancel")
                        ),
                        secondaryButton: .default(
                            Text("Settings"),
                            action: {
                                if let url = URL(string: UIApplication.openSettingsURLString),
                                   UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        )
                    )
                }
                .accentColor(Color("Color"))
                .onAppear() {
                    notificationManager.notificationAuthStatus()
                }
        }
        .onChange(of: notificationManager.authorizationStatus) { authorizationStatus in
            switch authorizationStatus {
            case .notDetermined:
                //request authorization
                notificationManager.requestNotificationAuth()
            case .denied:
                // authoization turned off by user
                self.showAuthAlert = true
            break
            default:
                break
            }
        }

    }
}

struct TreatmentsListView_Previews: PreviewProvider {
  static var previews: some View {
    TreatmentsListView()
  }
}
