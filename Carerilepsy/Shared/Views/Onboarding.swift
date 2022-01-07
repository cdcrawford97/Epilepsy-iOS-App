//
//  Onboarding.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 04/08/2021.
//

import SwiftUI

struct OnboardingStep {
    let image: String
    let title: String
    let description: String
}

private let onboardingSteps = [
    OnboardingStep(image: "onboarding1", title: "Seizure Diary", description: "Register seizures, triggers, rescue medications and organise by date"),
    OnboardingStep(image: "onboarding2", title: "Data Sharing", description: "Seamlessly share your seizure data with your neurologist to assist during consultations"),
    OnboardingStep(image: "onboarding3", title: "Treatment Notifications", description: "Set reminders for treatment plans such as medication, exercise and diet regimes")
]



struct Onboarding: View {
    
    @State private var currentStep = 0
    @AppStorage("isOnboarding") private var isOnboarding = true
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack{
            Color(.white)
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        self.currentStep = onboardingSteps.count - 1
                    }, label: {
                        Text("Skip")
                            .padding(16)
                            .foregroundColor(.gray)
                    })
                }
                TabView(selection: $currentStep) {
                    ForEach(0..<onboardingSteps.count){ i in
                        VStack{
                            Image(onboardingSteps[i].image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                            
                            Text(onboardingSteps[i].title)
                                .font(.title)
                                .bold()
                            
                            Text(onboardingSteps[i].description)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .padding(.top, 16)
                            
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack{
                    ForEach(0..<onboardingSteps.count){ i in
                        if i == currentStep {
                            Rectangle()
                                .frame(width: 20, height: 10)
                                .cornerRadius(10)
                                .foregroundColor(Color("Color"))
                        } else {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, 24)
                
                Button(action: {
                    if self.currentStep < onboardingSteps.count - 1 {
                        self.currentStep += 1
                    } else {
                        isOnboarding = false
                    }
                }) {
                    Text(currentStep < onboardingSteps.count - 1 ? "Next" : "Get started")
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color("Color"))
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
