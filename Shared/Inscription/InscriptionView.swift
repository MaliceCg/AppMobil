//
//  InscriptionView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

import SwiftUI

struct InscriptionView: View {
    @Binding var festivalId: FestivalID
    @State private var currentPage = "inscription"
    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            
            Text("Festival ID : \(festivalId.id)")
            Text("Je suis Inscription")
                .navigationBarBackButtonHidden(true)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

