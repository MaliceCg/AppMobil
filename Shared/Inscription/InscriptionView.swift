//
//  InscriptionView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

import SwiftUI

struct InscriptionView: View {
    @Binding var festivalId: FestivalID
    var body: some View {
        VStack {
        Text("Festival ID : \(festivalId.id)")
        Text("Je suis Inscription")
        }
    }
}

