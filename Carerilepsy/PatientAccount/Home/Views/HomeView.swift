//
//  Home.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 17/07/2021.
//

import SwiftUI
import SwiftUICharts



struct HomeView: View {
    
    
    @AppStorage("treatmentsCompleted") var treatmentsCompleted: Int = 0
    @AppStorage("treatmentCount") var treatmentCount: [Int] = [0]
    @AppStorage("todaysDate") var todaysDate: String = ""
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject var seizureStats = SeizureStatistics()
    
    // UI variables
    @State var currentDate: String = Date().customDate()
    
    var body: some View {

        ScrollView(.vertical, showsIndicators: false){
            
            VStack(spacing: 20) {
                
                //MARK: Title
                
                HStack{
                    Text("Home")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                    
                    Spacer()
                }
                
                //MARK: Progress Bar
                
                HStack{
                    ProgressBar(progress: (treatmentCount.reduce(0, +)) == 0 ? 0 : Float(treatmentsCompleted)/Float(treatmentCount.reduce(0, +)) )
                        .frame(width: 120.0, height: 120.0)
                        .padding(.vertical, 15)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    VStack(spacing: 5){
                        Text("Completed")
                            .foregroundColor(Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1)))
                            .bold()
                        Group{Text("\(treatmentsCompleted)").bold().foregroundColor(Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1))) + Text(" of ") + Text("\(treatmentCount.reduce(0, +))").bold().foregroundColor(Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1))) + Text(" treatments")}
                        Group{ Text("this ") + Text("Week").bold().foregroundColor(Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1))) }
                    }
                    .frame(width: 150, alignment: .topLeading)
                    .padding(.trailing, 10)
                    
                }
                
                //MARK: Graph

                HStack{
                    
                    let myCustomStyle = ChartStyle(backgroundColor: Color(#colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9764705882, alpha: 1)), accentColor: Color.blue, gradientColor: GradientColor(start: Color(#colorLiteral(red: 0.5019607843, green: 0.4431372549, blue: 0.6117647059, alpha: 1)), end: Color(#colorLiteral(red: 0.5019607843, green: 0.4431372549, blue: 0.6117647059, alpha: 1)).opacity(0.2)), textColor: Color(#colorLiteral(red: 0.5019607843, green: 0.4431372549, blue: 0.6117647059, alpha: 1)), legendTextColor: Color(#colorLiteral(red: 0.5019607843, green: 0.4431372549, blue: 0.6117647059, alpha: 1)), dropShadowColor: Color.gray.opacity(0.4))
                    
                    LineChartView(data: seizureStats.monthSeizureCount, title: "Seizures", legend: "past month", style: myCustomStyle, form: ChartForm.large, rateValue: seizureStats.seizureIncreasePerc, dropShadow: true)
                }

                //MARK: Treatment List
                
                VStack(alignment: .leading){
                    HStack{
                        Text(self.currentDate)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.bottom, 7)
                    
                    //MARK: TreatmentRow
                    ForEach (viewModel.treatmentTimes) { treatment in
                        TreatmentRow(treatment: treatment)
                    }
                    if viewModel.treatmentTimes.count == 0 {
                        HStack{
                            Spacer()
                            Text("No active treatments left for today")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .padding(.top, 15)
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 15)
                    

            }
            .padding()
            
        }
        .onAppear(){
            viewModel.createTreatmentTimes()
            seizureStats.fetchData(dateRange: Date().startOf30Days()..<Date().endOfDay())
            todaysDate = Date().customDate()
        }
        .onChange(of: todaysDate) { _ in
            if treatmentCount.count < 7 {
                treatmentCount.append(0)
            }
            else if treatmentCount.count == 7 {
                treatmentCount.removeFirst(1)
                treatmentCount.append(0)
            }
        }
        .environmentObject(self.viewModel)

    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ProgressBar: View {
    
    var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1)).opacity(0.35))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1)))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.title)
                .bold()
        }
    }
}


struct TreatmentRow: View {
    
    var treatment: TreatmentTime
    @State var showDetail = false
    @State var showTreatment = true
    
    var body: some View {
        VStack {
            if showTreatment {
                if !showDetail{
                    
                    //MARK: TreatmentRow
                    
                    HStack{
                        Image("pills")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 2)
                            .padding(.trailing, 8)
                        VStack(alignment: .leading, spacing: 3){
                            Text("\(treatment.name)")
                                .foregroundColor(Color(#colorLiteral(red: 0.368627451, green: 0.3764705882, blue: 0.5529411765, alpha: 1)))
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                            Text("\(treatment.dosage)")
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text(treatment.time, style: .time)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color(#colorLiteral(red: 0.368627451, green: 0.3764705882, blue: 0.6039215686, alpha: 1)).opacity(0.8))
                                .cornerRadius(20)
                            Spacer()
                        }
                        .padding(.trailing, 1)
                        .padding(.top, 5)
                        
                    }
                    .padding()
                    .background(Color(#colorLiteral(red: 0.9137254902, green: 0.9411764706, blue: 1, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 7)
                    .shadow(radius: 4)
                    
                    
                }
                
                if showDetail {
                    TreatmentRowExpand(showDetail: self.$showDetail, showTreatment: self.$showTreatment, treatment: treatment)
                }
                
            }
        }
        .onTapGesture {
            withAnimation {
                self.showDetail.toggle()
            }
        }
    }
}

struct TreatmentRowExpand: View {
    
    @Binding var showDetail: Bool
    @Binding var showTreatment: Bool
    @State var treatment: TreatmentTime
    
    @AppStorage("treatmentsCompleted") var treatmentsCompleted: Int = 0
    @AppStorage("treatmentCount") var treatmentCount: [Int] = [0]
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        
        //MARK: ExpandedTreatmentRow
        VStack {
            HStack{
                Image("pills")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 2)
                    .padding(.trailing, 8)
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 3){
                    Text("\(treatment.name)")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                    Text("\(treatment.dosage)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                }
                
                Spacer()
                
                VStack{
                    Text(treatment.time, style: .time)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color(#colorLiteral(red: 0.368627451, green: 0.3764705882, blue: 0.6039215686, alpha: 1)).opacity(0.8))
                        .cornerRadius(20)
                    Spacer()
                }
                .padding(.trailing, 1)
                .padding(.top, 5)
                
            }
            
            Rectangle()
                .fill(Color.white)
                .frame(height: 2)
                .padding(.vertical)
            
            HStack{
                Spacer()
                Button(action: {
                    withAnimation {
                        treatmentCount[treatmentCount.endIndex-1] = treatmentCount.last! + 1
                        self.showTreatment = false
                    }
                }){
                    HStack{
                        Image(systemName: "xmark")
                        Text("Skip")
                    }
                    .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        treatmentsCompleted += 1
                        treatmentCount[treatmentCount.endIndex-1] = treatmentCount.last! + 1
                        self.showTreatment = false
                    }
                }){
                    HStack{
                        Image(systemName: "checkmark")
                        Text("Done")
                    }
                    .foregroundColor(.white)
                }
                
                Spacer()
            }
            
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.368627451, green: 0.3764705882, blue: 0.6039215686, alpha: 1)))
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .padding(.bottom, 7)
        .shadow(radius: 4)
        .onTapGesture {
            withAnimation {
                self.showDetail.toggle()
            }
        }
    }
}

