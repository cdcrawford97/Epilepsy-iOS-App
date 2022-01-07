//
//  CarerilepsyTests.swift
//  CarerilepsyTests
//
//  Created by Cameron Crawford on 30/08/2021.
//

import XCTest
@testable import Carerilepsy

class CarerilepsyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: Initializing Models

    func testSeizureInit() throws {
        let seizure = Seizure(id: UUID().uuidString, dateTime: Date(), numberOf: 1, clusterOrSeizure: "Seizure", type: "", minutes: 0, seconds: 0, trigger: "None", rescueMed: "", remarks: "")
        XCTAssertNotNil(seizure)
    }
    
    func testTreatmentInit() throws {
        let treatment = Treatment(id: UUID().uuidString, type: "", intake: "", name: "", dosage: "", dosageUnit: "", time: [Date()], startDate: Date(), daily: true, days: [TreatmentDay(dayName: "Mon", toggleValue: true), TreatmentDay(dayName: "Tue", toggleValue: true), TreatmentDay(dayName: "Wed", toggleValue: true), TreatmentDay(dayName: "Thu", toggleValue: true), TreatmentDay(dayName: "Fri", toggleValue: true), TreatmentDay(dayName: "Sat", toggleValue: true), TreatmentDay(dayName: "Sun", toggleValue: true)], comment: "")
        XCTAssertNotNil(treatment)
    }
    
    func testPatientInit() throws {
        let patient = Patient(id: UUID().uuidString, name: "", email: "", uuid: UUID().uuidString)
        XCTAssertNotNil(patient)
    }
    
    func testClinicianInit() throws {
        let clinician = Clinician(id: UUID().uuidString, name: "", email: "", uuid: UUID().uuidString, status: "Pending")
        XCTAssertNotNil(clinician)
    }
    
    func testTreatmentTimeInit() throws {
        let time = TreatmentTime(name: "AED", dosage: "30mg", time: Date())
        XCTAssertNotNil(time)
    }


}
