//
//  ClockView.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 15/08/2021.
//

import SwiftUI

struct ClockView: View {
    
    @EnvironmentObject var dateModel: DateViewModel
    @EnvironmentObject var viewModel: TreatmentViewModel
    var index: Int

    
    var body: some View {
              
        // MARK: - Custom Time Picker
        
        if dateModel.showPicker {
            
            VStack(spacing: 0) {
                
                HStack(spacing: 18) {
                    
                    // MARK: - Hour and Minute
                    
                    Spacer()
                    HStack(spacing: 0) {
                        
                        Text("\(dateModel.hour):")
                            .font(.largeTitle)
                            .fontWeight(dateModel.changeToMin ? .light : .bold)
                            .foregroundColor(.black)
                            .onTapGesture {
                                //updating angle values
                                dateModel.angle = Double(dateModel.hour * 30)
                                dateModel.changeToMin = false
                            }
                        Text("\(dateModel.minutes < 10 ? "0" : "")\(dateModel.minutes)")
                            .font(.largeTitle.monospacedDigit())
                            .fontWeight(dateModel.changeToMin ? .bold : .light)
                            .foregroundColor(.black)
                            .onTapGesture {
                                dateModel.angle = Double (dateModel.minutes * 6)
                                dateModel.changeToMin = true
                            }
                    }
                    
                    // MARK: - AM and PM selectors
                    
                    VStack(spacing: 8) {
                        Text("AM")
                            .font(.title2)
                            .fontWeight(dateModel.symbol == "AM" ? .bold : .light)
                            .foregroundColor(.black)
                            .onTapGesture {
                                dateModel.symbol = "AM"
                            }
                        
                        Text("PM")
                            .font(.title2)
                            .fontWeight(dateModel.symbol == "PM" ? .bold : .light)
                            .foregroundColor(.black)
                            .onTapGesture {
                                dateModel.symbol = "PM"
                            }
                    }
                    .frame(width: 50)
                }
                .padding()
                
                // MARK: - Clock View
                
                ClockSlider()
                
                // MARK: - Save Button
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dateModel.generateTime()
                        viewModel.treatment.time[index - 1] = dateModel.selectedDate
                    }, label: {
                        Text("Save")
                            .fontWeight(.bold)
                    })
                }
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width - 120)
            .background(Color(#colorLiteral(red: 0.9137254902, green: 0.9411764706, blue: 1, alpha: 1)))
            .cornerRadius(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.3).ignoresSafeArea().onTapGesture {
                withAnimation(.spring()){
                    dateModel.showPicker.toggle()
                }
            })
        }
    }
}

struct ClockSlider: View {
    
    @EnvironmentObject var dateModel: DateViewModel
    
    var body: some View {
        GeometryReader{ reader in
            
            ZStack {
                
                let width = reader.frame(in: .global).width / 2
                
                // Clock Hand Circle End
                Circle()
                    .fill(Color("Color").opacity(0.5))
                    .frame(width: 40, height: 40)
                    .offset(x: width - 50)
                    .rotationEffect(.init(degrees: dateModel.angle))
                    .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                    .rotationEffect(.init(degrees: -90))
                    
                // Clock Numbers
                ForEach(1...12, id: \.self){ index in
                    VStack{
                        Text("\(dateModel.changeToMin ? index * 5 : index)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(-index) * 30 ))
                    }
                    .offset(y: -width + 50)
                    .rotationEffect(.init(degrees: Double(index) * 30))
                }
                
                // Clock Hand Arrow
                Circle()
                    .fill(Color("Color"))
                    .frame(width: 10, height: 10)
                    .overlay(
                        
                        Rectangle()
                            .fill(Color("Color"))
                            .frame(width: 2, height: width / 2)
                            
                        ,alignment: .bottom
                    
                    )
                    .rotationEffect(.init(degrees: dateModel.angle))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 300)
        
    }
    
    func onChanged(value: DragGesture.Value) {
        
        // getting angle
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        let radians = atan2(vector.dy - 20, vector.dx - 20)
        var angle = radians * 180 / .pi
        if angle < 0{angle = 360 + angle}
        
        dateModel.angle = Double(angle)
        
        if !dateModel.changeToMin {
            
            let roundValue = 30 * Int(round(dateModel.angle / 30))
            
            dateModel.angle = Double(roundValue)
        } else{
            // updating mins
            let progress = dateModel.angle / 360
            dateModel.minutes = Int(progress * 60)
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        
        if !dateModel.changeToMin {
            
            // updating hour value
            dateModel.hour = Int(dateModel.angle / 30)
            
            //updating picker to mins
            withAnimation {
                dateModel.angle = Double(dateModel.minutes * 6)
                dateModel.changeToMin =  true
            }
            
        }
        
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(index: 1)
    }
}
