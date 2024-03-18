//
//  DashboardView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 15/03/2024.
//

import SwiftUI

struct DashboardView: View {
    @Binding var selectedFestivalId: FestivalID

       var body: some View {
           VStack {
           Text("Festival ID : \(selectedFestivalId.id)")
           Text("Je suis Dashboard")
               .navigationBarBackButtonHidden(true)
           }
       }
}



