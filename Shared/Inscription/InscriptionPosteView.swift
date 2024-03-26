//
//  InscriptionView.swift
//  AppMobile (iOS)
//
//  Created by Nathan BELLUS on 16/03/2024.
//

import SwiftUI


struct InscriptionPosteView: View {
    @Binding var festivalId: FestivalID
    @ObservedObject var viewModel: InscriptionViewModel
    @State private var currentPage = "inscription"
    @State private var isLoading = true // Ajoute une propriété pour suivre l'état du chargement
    @Binding var isInscriptionCreneauViewActive: Bool

    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )

            Text("Veuillez choisir le poste où vous souhaitez vous inscrire : ")
                .font(.system (size:20))
                .frame(maxWidth: .infinity, alignment: .center)

            if isLoading { // Affiche le texte "Chargement..." lorsque les données sont en cours de chargement
                Text("Chargement...")
            } else { // Affiche les boutons lorsque les données sont chargées
                if let positions = viewModel.state.filteredPositions {
                    ScrollView {
                        LazyVStack {
                            ForEach(positions) { position in
                                Button(action: {
                                  if(position.nomPoste == "Animation Jeux"){
                                  } else {
                                    isInscriptionCreneauViewActive = true
                                    self.viewModel.selectedPosition = position
                                    self.viewModel.send(intent: .navigateToInscriptionCreneauView)
                                  }
                                }) {
                                    Text(position.nomPoste)
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: 280, height: 70)
                                        .background(viewModel.getColorForPosition(position: position))
                                        .cornerRadius(10)
                                }
                                .padding(5)
                            }
                        }
                    }
                }

                Text("Je suis flexible sur les postes")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                    .underline()
                    .onTapGesture {
                        // Action à effectuer lorsque le texte est pressé
                    }
                    .padding()
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            viewModel.send(intent: .fetchPositionFestival)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Attend une seconde pour simuler le chargement des données
                self.isLoading = false // Met à jour l'état du chargement
            }
        }
    }
}



