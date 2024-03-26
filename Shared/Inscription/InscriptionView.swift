//
//  InscriptionView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

import SwiftUI


struct InscriptionView: View {
    @Binding var festivalId: FestivalID
    @ObservedObject var viewModel: InscriptionViewModel
    @Binding var isInscriptionCreneauViewActive: Bool

    var body: some View {
        VStack {
            if isInscriptionCreneauViewActive {
                InscriptionCreneauView(festivalId: $festivalId, viewModel: viewModel)
            } else {
                InscriptionPosteView(festivalId: $festivalId, viewModel: viewModel, isInscriptionCreneauViewActive: $isInscriptionCreneauViewActive)
            }
        }
        .onChange(of: isInscriptionCreneauViewActive) { newValue in
            // La vue sera automatiquement mise à jour grâce au `if` dans le `body`
        }
    }
}





