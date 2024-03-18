//
//  ActivitesView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

import SwiftUI

struct ActivitesView: View {
    @Binding var festivalId: FestivalID
    @State private var currentPage = "activites"
    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            Text("Festival ID : \(festivalId.id)")
            Text("Je suis Activites")
                .navigationBarBackButtonHidden(true)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

