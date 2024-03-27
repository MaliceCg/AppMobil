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
    @Binding var isInscriptionZoneViewActive: Bool
    @State private var isFlexibleSheetPresented = false
  


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
                                    isInscriptionZoneViewActive = true
                                    self.viewModel.selectedPosition = position
                                    self.viewModel.send(intent: .navigateToInscriptionZoneView)
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
                      self.isFlexibleSheetPresented = true
                    }
                    .padding()
            }

            Spacer()
        }
          .sheet(isPresented: $isFlexibleSheetPresented) { // Ajoute la méthode .sheet
            FlexiblePosteView(viewModel: viewModel, isInscriptionCreneauViewActive: $isInscriptionCreneauViewActive) // Remplacez par votre vue personnalisée
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

struct FlexiblePosteView: View {
    @ObservedObject var viewModel: InscriptionViewModel
    @State private var selectedPostes: Set<Position> = [] // Ensemble des postes sélectionnés
    @Binding var isInscriptionCreneauViewActive: Bool

    var body: some View {
        VStack {
            Form {
                ForEach(viewModel.state.filteredPositions.filter { $0.nomPoste != "Animation Jeux" }, id: \.self) { position in
                    HStack {
                        Text(position.nomPoste)
                        Spacer()
                        Toggle("", isOn: Binding<Bool>(
                            get: { self.selectedPostes.contains(position) },
                            set: { isOn in
                                if isOn {
                                    self.selectedPostes.insert(position)
                                } else {
                                    self.selectedPostes.remove(position)
                                }
                            }
                        ))
                    }
                }
            }
            .padding()

            Button(action: {
              isInscriptionCreneauViewActive = true
              self.viewModel.flexiblePosition = Array(self.selectedPostes)
              self.viewModel.send(intent: .navigateToInscriptionCreneauView)
            }) {
                Text("Valider")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}




