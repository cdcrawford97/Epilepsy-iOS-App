//
//  DataView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 08/08/2021.
//

import SwiftUI

//MARK:- Bar Chart Data
struct DataPoint: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: CGFloat
    let width: CGFloat
}

struct DataView: View {
    
    var patient: Patient
    @State var firstPickerSelectedItem = 0
    @State var secondPickerSelectedItem = 0
    @State var dateRange: Range<Date>
    @StateObject var patientData = PatientDataViewModel()
    var daysOfWeek = Date().daysOfWeek()
    var daysOfMonthFirstHalf = Date().last30DaysFirst15()
    var daysOfMonthSecondHalf = Date().last30DaysSecond15()
    let monthsOfYearFirstHalf = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let monthsOfYearSecondHalf = ["Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var body: some View {
        
        VStack{
            
            ScrollView(.vertical, showsIndicators: false){
                
                Text("Seizure Statistics")
                    .font(.system(size: 28))
                    .fontWeight(.heavy)
                
                Picker(selection: $firstPickerSelectedItem.animation(), label: Text("")){
                    Text("Last 7 Days").tag(0)
                    Text("Last 30 Days").tag(1)
                    Text("This Year").tag(2)
                }
                .onChange(of: firstPickerSelectedItem) { tag in
                    if tag == 0 {
                        self.dateRange = Date().startOfWeek()..<Date().endOfDay()
                    }
                    else if tag == 1 {
                        self.dateRange = Date().startOf30Days()..<Date().endOfDay()
                    }
                    else if tag == 2 {
                        self.dateRange = Date().startOfYear()..<Date().EndOfYear()
                    }
                    self.patientData.fetchData(patient: self.patient, dateRange: self.dateRange, secondSelectedPicker: self.secondPickerSelectedItem)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 24)
                
                VStack{
                    
                    // MARK: - Last 7 Days data
                    
                    if firstPickerSelectedItem == 0 {
                        HStack(spacing: 18) {
                            ForEach(0...6, id: \.self) {
                                SingleBarView(value: CGFloat(Double(patientData.seizureCount[$0])/Double(patientData.seizureCount.max()! == 0 ? 1 : patientData.seizureCount.max()!)), count: patientData.seizureCount[$0], barUnit: daysOfWeek[$0], width: 30)
                            }
                        }
                        .padding(.top, 20)
                        .animation(.default)
                    }
                    
                    // MARK: - Last 30 Days data
                    
                    if firstPickerSelectedItem == 1 {
                        VStack(spacing: 18){
                            HStack(spacing: 5) {
                                ForEach(0...14, id: \.self) {
                                    SingleBarView(value: CGFloat(Double(patientData.monthSeizureCountFirstHalf[$0])/Double(patientData.monthSeizureCountFirstHalf.max()! == 0 ? 1 : patientData.monthSeizureCountFirstHalf.max()!)), count: patientData.monthSeizureCountFirstHalf[$0], barUnit: daysOfMonthFirstHalf[$0], width: 14)
                                }
                            }
                            HStack(spacing: 4) {
                                ForEach(0...14, id: \.self) {
                                    SingleBarView(value: CGFloat(Double(patientData.monthSeizureCountSecondHalf[$0])/Double(patientData.monthSeizureCountSecondHalf.max()! == 0 ? 1 : patientData.monthSeizureCountSecondHalf.max()!)), count: patientData.monthSeizureCountSecondHalf[$0], barUnit: daysOfMonthSecondHalf[$0], width: 14)
                                }
                            }
                        }
                        .padding(.top, 20)
                        .animation(.default)
                        
                    }
                    
                    // MARK: - Year Data

                    if firstPickerSelectedItem == 2 {
                        VStack(spacing: 18){
                            HStack(spacing: 18) {
                                ForEach(0...5, id: \.self) {
                                    SingleBarView(value: CGFloat(Double(patientData.yearSeizureCountFirstHalf[$0])/Double(patientData.yearSeizureCountFirstHalf.max()! == 0 ? 1 : patientData.yearSeizureCountFirstHalf.max()!)), count: patientData.yearSeizureCountFirstHalf[$0], barUnit: monthsOfYearFirstHalf[$0], width: 30)
                                }
                            }
                            HStack(spacing: 18) {
                                ForEach(0...5, id: \.self) {
                                    SingleBarView(value: CGFloat(Double(patientData.yearSeizureCountSecondHalf[$0])/Double(patientData.yearSeizureCountSecondHalf.max()! == 0 ? 1 : patientData.yearSeizureCountSecondHalf.max()!)), count: patientData.yearSeizureCountSecondHalf[$0], barUnit: monthsOfYearSecondHalf[$0], width: 30)
                                }
                            }
                        }
                        .padding(.top, 20)
                        .animation(.default)
                    }
                    
                    // MARK: - Seizure Duration Stat
                    VStack{
                        Divider()
                        HStack{
                            Text("Average Seizure Duration:")
                            Spacer()
                            Text("\(patientData.averageSeizureDurationMinutes) min(s), \(patientData.averageSeizureDurationSeconds) s")
                                .bold()
                        }
                        .padding(.vertical, 10)
                        Divider()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    
                    
                    // MARK: - Pie Chart
                    
                    Picker(selection: $secondPickerSelectedItem.animation(), label: Text("")){
                        Text("Trigger Frequency").tag(0)
                        Text("Seizure Types").tag(1)
                    }
                    .onChange(of: secondPickerSelectedItem) { tag in
                        self.patientData.fetchData(patient: self.patient, dateRange: self.dateRange, secondSelectedPicker: tag)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                    .padding(.top, 15)
                    .padding(.bottom, 20)
              
                    PieChart()
                        .environmentObject(self.patientData)
                    
                }
                .background(
                    Color.white
                        .cornerRadius(25)
                        .shadow(radius: 7)
                )
                .padding()
                
            }
            .padding(.top, 20)

        }
        .onChange(of: self.patient, perform: { patient in
            self.patientData.fetchData(patient: patient, dateRange: self.dateRange, secondSelectedPicker: secondPickerSelectedItem)
        })
        .onAppear() {
            self.patientData.fetchData(patient: self.patient, dateRange: self.dateRange, secondSelectedPicker: secondPickerSelectedItem)
        }
        
        
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(patient: Patient(id: "", name: "", email: "", uuid: ""), dateRange: Date()..<Date())
    }
}


//MARK:- Bar Chart Single Column
struct SingleBarView: View {
    var value: CGFloat
    var count: Int
    var barUnit: String
    var width: CGFloat
    
    var body: some View {
        VStack{
            ZStack (alignment: .bottom) {
                Capsule().frame(width: width, height: 150)
                    .foregroundColor(Color(#colorLiteral(red: 0.937254902, green: 0.9137254902, blue: 1, alpha: 1)))
                Capsule().frame(width: width, height: value*150)
                    .foregroundColor(Color("Color").opacity(0.7))
                Text("\(count)")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .bold()
                    .padding(.vertical, 5)
            }
            Text(barUnit)
                .font(.system(size: 15))
        }
    }
}


//MARK:- Pie Chart
struct PieChart : View {
    
    @EnvironmentObject var patientData: PatientDataViewModel
    @State var indexOfTappedSlice = -1
    
    var body: some View {
        VStack {
            //MARK:- Pie Slices
            ZStack {
                if patientData.chartData.count > 0 {
                    ForEach(0..<patientData.chartData.count, id: \.self) { index in
                        Circle()
                            .trim(from: index == 0 ? 0.0 : patientData.chartData[index-1].value/100,
                                  to: patientData.chartData[index].value/100)
                            .stroke(patientData.chartData[index].color,lineWidth: 100)
                            .scaleEffect(index == indexOfTappedSlice ? 1.1 : 1.0)
                            .animation(.spring())
                    }
                }
            }
            .frame(width: 100, height: 200)
            .shadow(radius: 8)
            
            //MARK:- Description
            
            if patientData.chartData.count > 0 {
                ForEach(0..<patientData.chartData.count, id: \.self) { index in
                    HStack {
                        
                        Text(patientData.chartData[index].label)
                            .font(indexOfTappedSlice == index ? .headline : .subheadline)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", Double(patientData.chartData[index].percent))+"%")
                            .font(indexOfTappedSlice == index ? .headline : .subheadline)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(patientData.chartData[index].color)
                            .frame(width: 15, height: 15)
                    }
                    .onTapGesture {
                        indexOfTappedSlice = indexOfTappedSlice == index ? -1 : index
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 30)
                .frame(width: 300, alignment: .trailing)
            }
            
        }
    }
}
