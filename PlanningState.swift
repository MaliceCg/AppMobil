//
//  PlanningState.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 14/03/2024.
//

import Foundation

class PlanningState: ObservableObject {
    @Published var festival: Festival? = nil
    @Published var positions: [Position] = []
    @Published var employers: [Employer] = []
    @Published var inscriptions: [Inscription] = []
    @Published var timeSlots: [String] = ["09-11", "11-14", "14-17", "17-20", "20-22"]
}



