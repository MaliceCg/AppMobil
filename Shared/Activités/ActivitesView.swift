//
//  ActivitesView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

import SwiftUI
struct ActivitesView: View {
    @Binding var festivalId: FestivalID
    @ObservedObject var viewModel: ActiviteViewModel
    @State private var currentPage = "activites"
    
    init(festivalId: Binding<FestivalID>, viewModel: ActiviteViewModel) {
        self._festivalId = festivalId
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            Text("Festival ID : \(festivalId.id)")
            Text("Je suis Activites")
                .navigationBarBackButtonHidden(true)
            // Affichez les inscriptions ici
            if viewModel.state.loading {
                ProgressView()
            } else {
                ScrollView {
                    Text("Activites")
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(viewModel.state.inscription, id: \.self) { inscription in
                            InscriptionSquareView(inscription: inscription, viewModel: viewModel)
                        }

                    }
                }
            }
            Spacer()
        }
        .background(Color(red: 0.8588, green: 0.8588, blue: 0.8588, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            viewModel.send(intent: .fetchPostes) // Récupérez les posts lorsque la vue apparaît
        }
    }
}
struct InscriptionSquareView: View {
    let inscription: Inscription
    @ObservedObject var viewModel: ActiviteViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let post = viewModel.state.posts.first(where: { $0.idPoste == inscription.idPoste }) {
                Text("\(post.nomPoste)")
                    .font(.headline)
            }
            HStack {
                Text("Creneau: \(inscription.Creneau)")
                Spacer()
                if let zone = viewModel.state.zones.first(where: { $0.idZoneBenevole == inscription.idZoneBenevole }) {
                    Text("Zone: \(zone.nomZoneBenevole)")
                }
            }
            if let post = viewModel.state.posts.first(where: { $0.idPoste == inscription.idPoste }) {
                Text("Description: \(post.description)")
            }
            // Afficher les identifiants des bénévoles pour chaque poste
            if let referentRelations = viewModel.state.referentRelation.filter({ $0.idPoste == inscription.idPoste }) {
                let benevoleIds = referentRelations.map({ $0.idBenevole })
                ForEach(benevoleIds, id: \.self) { benevoleId in
                    Text("Bénévole ID: \(benevoleId)")
                }
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
