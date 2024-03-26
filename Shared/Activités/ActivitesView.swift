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
                            InscriptionSquareView(inscription: inscription)
                        }
                    }
                }
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            viewModel.send(.fetchInscription) // Récupérez les inscriptions lorsque la vue apparaît
        }
    }
}

struct InscriptionSquareView: View {
    let inscription: Inscription

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("idPoste: \(inscription.idPoste)")
                .font(.headline)
            HStack {
                Text("Creneau: \(inscription.Creneau)")
                Spacer()
                Text("Jour: \(inscription.Jour)")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
