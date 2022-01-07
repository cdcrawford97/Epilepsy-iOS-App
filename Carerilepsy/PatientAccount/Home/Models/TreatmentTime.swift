//
//  Home.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 25/07/2021.
//

import Foundation

struct TreatmentTime: Identifiable {
    let id = UUID()
    let name: String
    let dosage: String
    let time: Date
}
