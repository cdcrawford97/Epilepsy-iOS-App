//
//  SeizuresListView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 01/08/2021.
//

import SwiftUI

struct SeizuresListView: View {
    

    // Year Month Selector Variables
    @State var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State var selectedMonth: String = Date().monthShort()
    let months: [String] = Calendar.current.shortMonthSymbols
    @State var dateRange: Range<Date>
    
    
    
    // MARK: - State
    @StateObject var viewModel = SeizuresViewModel()
    @State var presentAddSeizureSheet = false
    
    // MARK: - UI Components
    private var addButton: some View {
        Button(action: { self.presentAddSeizureSheet.toggle() }) {
            HStack {
                Text("Add")
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }
        }
    }
  
    private func seizureRowView(seizure: Seizure) -> some View {
        NavigationLink(destination: SeizureDetailsView(seizure: seizure)) {
            
            VStack(alignment: .leading) {
                Text(seizure.type)
                    .font(.headline)
                Text(seizure.dateTime.seizureListCustomDate())
                        .font(.subheadline)
                Text("\(seizure.minutes)m \(seizure.seconds)s")
                    .font(.subheadline)
            }
            
        }
    }
    
    
    var body: some View {
    
        VStack(spacing:0) {
            Group {
                HStack {
                    Image(systemName: "chevron.left")
                        .frame(width: 24.0)
                        .onTapGesture {
                            selectedYear -= 1;
                            selectedMonth = ""
                        }
                    Text(String(selectedYear))
                        .fontWeight(.bold)
                        .transition(.move(edge: .trailing))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .frame(width: 24.0)
                        .onTapGesture {
                            selectedYear += 1;
                            selectedMonth = ""
                        }
                }.padding(.all, 12.0)
                .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9764705882, alpha: 1)))
            }
            Group {
                ScrollView(.horizontal) {
                    ScrollViewReader { scrollView in
                        HStack() {
                            ForEach(months, id: \.self) { item in
                                Text(item)
                                    .foregroundColor((item == selectedMonth) ? Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1)): .black)
                                    .font((item == selectedMonth) ? .system(size: 20): .system(size: 17))
                                    .padding(.all, 12.0)
                                    .onTapGesture {
                                        self.setPeriod(selectedMonth: item)
                                    }
                            }
                        }
                        .onAppear() {
                            scrollView.scrollTo(selectedMonth, anchor: .leading)
                        }
                    }
                }
            }
            Divider()
            
            List {
                ForEach (viewModel.seizures) { seizure in
                    seizureRowView(seizure: seizure)
                }
                if viewModel.seizures.count == 0 {
                    Text("No recorded seizures for this month.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITableView.selectionDidChangeNotification)) {
                guard let tableView = $0.object as? UITableView,
                      let selectedRow = tableView.indexPathForSelectedRow else { return }

                tableView.deselectRow(at: selectedRow, animated: true)
            }
            
        }
        .onAppear() {
            DispatchQueue.main.async {
                self.viewModel.fetchData(dateRange: self.dateRange)
                selectedYear = Int(dateRange.lowerBound.yearFull())!
                selectedMonth = dateRange.lowerBound.monthShort()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton
            }
        }
        .sheet(isPresented: self.$presentAddSeizureSheet) {
            SeizureEditView()
                .accentColor(Color("Color"))
        }
        
    }
    
    
    func setPeriod(selectedMonth: String) {
        self.selectedMonth = selectedMonth
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyy"
        let startDate = dateFormatter.date(from: "01/" + selectedMonth + "/" + String(selectedYear))
        let endDate = startDate?.endOfMonth()
        self.dateRange = .init(uncheckedBounds: (lower: startDate!, upper: endDate!))
        self.viewModel.fetchData(dateRange: self.dateRange)
    }
    
    
}

struct SeizuresListView_Previews: PreviewProvider {
    static var previews: some View {
        SeizuresListView(dateRange: .init(uncheckedBounds: (lower: Calendar.current.date(byAdding: .month, value: 2, to: Date())!.startOfMonth(), upper: Calendar.current.date(byAdding: .month, value: 2, to: Date())!.endOfMonth()  )))
    }
}
