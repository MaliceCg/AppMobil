//
//  InscriptionZoneView.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 26/03/2024.
//

import SwiftUI

struct InscriptionZoneView: View {
    @Binding var festivalId: FestivalID
    @ObservedObject var viewModel: InscriptionViewModel
    @Binding var isInscriptionCreneauViewActive: Bool
    @Binding var isInscriptionZoneViewActive: Bool
    @State private var currentPage = "inscription"
    @State private var selectedZone: Zone?
    

    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )

            Text("Veuillez choisir la zone où vous souhaitez vous inscrire : ")
                .font(.system (size:20))
                .frame(maxWidth: .infinity, alignment: .center)

            ScrollView {
                LazyVStack {
                    if let zones = viewModel.zones {
                        ForEach(zones) { zone in
                            Button(action: {
                                self.selectedZone = zone
                            }) {
                                Text(zone.nomZoneBenevole)
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 280, height: 70)
                                    .background(Color(red: 0.06274509803921569, green: 0.3607843137254902, blue: 0.6235294117647059))
                                    .cornerRadius(10)
                            }
                            .sheet(item: $selectedZone) { zone in
                              ZoneDetailView(viewModel: viewModel, zone: zone, isInscriptionCreneauViewActive: $isInscriptionCreneauViewActive, isInscriptionZoneViewActive: $isInscriptionZoneViewActive)
                            }
                        }
                    }
                }
                .padding()
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {

        }
    }
}


struct ZoneDetailView: View {
    @ObservedObject var viewModel: InscriptionViewModel
    let zone: Zone
  
    @Binding var isInscriptionCreneauViewActive: Bool
    @Binding var isInscriptionZoneViewActive: Bool
    

    var body: some View {
        ZStack {
            Color(red: 0.06274509803921569, green: 0.3607843137254902, blue: 0.6235294117647059)
                .ignoresSafeArea()
            VStack {
                Text(zone.nomZoneBenevole)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                Spacer()

                // Ajoutez cette vue Text ici
                Text("Liste des jeux à animer pour cette zone")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                if let games = viewModel.games {
                    List(games) { game in
                        Text(game.NomJeu)
                    }
                    .listStyle(PlainListStyle())
                    .padding()
                }

                // Ajoutez cette vue Button ici
                Button(action: {
                  isInscriptionZoneViewActive = false
                  isInscriptionCreneauViewActive = true
                  self.viewModel.zoneSelected = zone
                  self.viewModel.send(intent: .navigateToInscriptionCreneauView)
                }) {
                    Text("S'inscrire")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchGamesForZone(idZone: zone.idZoneBenevole)
            }
        }
    }
}


