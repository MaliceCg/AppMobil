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
    @Binding var isInscriptionCreneauViewActive: Bool
    @Binding var isInscriptionZoneViewActive: Bool
    @State private var isFlexibleSheetPresented = false
  


    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )

            Text("Veuillez choisir le poste où vous souhaitez vous inscrire : ")
                .font(.system (size:20))
                .frame(maxWidth: .infinity, alignment: .center)

            if viewModel.state.loading { // Affiche le texte "Chargement..." lorsque les données sont en cours de chargement
                ProgressView()
            } else { // Affiche les boutons lorsque les données sont chargées
              
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.filteredPositions) { position in
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
        }
    }
}

struct FlexiblePosteView: View {
    @ObservedObject var viewModel: InscriptionViewModel
    @State private var selectedPostes: Set<Position> = [] // Ensemble des postes sélectionnés
    @Binding var isInscriptionCreneauViewActive: Bool

    var body: some View {
        VStack {
            
            // Ajoutez cette vue Text ici
            Text("Choisissez les postes sur lesquels vous souhaitez être flexibe : ")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
          
            Form {
                ForEach(viewModel.filteredPositions.filter { $0.nomPoste != "Animation Jeux" }, id: \.self) { position in
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
            .disabled(selectedPostes.isEmpty)
            .opacity(selectedPostes.isEmpty ? 0.5 : 1.0)
            .padding()
        }
    }
}
