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
                .navigationBarBackButtonHidden(true)
            
            
            // Affichez les inscriptions ici
            if viewModel.state.loading {
                ProgressView()
            } else {
                ScrollView {
                    VStack {
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
    let postColors: [String: Color] = [
            "Accueil": Color(red: 0.23529411764705882, green: 0.796078431372549, blue: 0.9568627450980393),
            "Buvette": Color(red: 0.06666666666666667, green: 0.4980392156862745, blue: 0.27058823529411763),
            "Animation Jeux": Color(red: 0.06274509803921569, green: 0.3607843137254902, blue: 0.6235294117647059),
            "Cuisine": Color(red: 0.2, green: 0.7686274509803922, blue: 0.5058823529411764)
        ]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let post = viewModel.state.posts.first(where: { $0.idPoste == inscription.idPoste }) {
                Text("\(post.nomPoste)")
                    .font(.title)
                    .fontWeight(.bold)
            }
            HStack {
                Text("\(inscription.Creneau)")
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()
                if let zone = viewModel.state.zones.first(where: { $0.idZoneBenevole == inscription.idZoneBenevole }) {
                    Text("\(zone.nomZoneBenevole)")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            if let post = viewModel.state.posts.first(where: { $0.idPoste == inscription.idPoste }) {
                Text("Description: \(post.description)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            // Afficher les identifiants des bénévoles pour chaque poste
            if let referentRelations = viewModel.state.referentRelation.filter({ $0.idPoste == inscription.idPoste }) {
                let benevoleIds = referentRelations.map({ $0.idBenevole })
                ForEach(benevoleIds, id: \.self) { benevoleId in
                    Text("Bénévole ID: \(benevoleId)")
                }
            }
//            Button(action: {
//                            // Appelez la fonction unsubscribe du viewModel
//                            viewModel.send(intent: .unsubscribe(inscription.idPoste, inscription.idZoneBenevole, inscription.Creneau, inscription.Jour))
//                        }) {
//                            Text("Se désinscrire")
//                                .font(.caption) // Utilisez une police plus petite
//                                .foregroundColor(.white)
//                                .padding(.horizontal, 8) // Réduisez le padding horizontal
//                                .padding(.vertical, 4) // Réduisez le padding vertical
//                                .background(Color.gray) // Changez la couleur de fond en gris
//                                .cornerRadius(10)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .trailing) // Alignez le bouton à droite
//
        }
        .padding()
        .frame(maxWidth:350)
        .background(
            Group {
                if let post = viewModel.state.posts.first(where: { $0.idPoste == inscription.idPoste }) {
                    postColors[post.nomPoste, default: .white]
                    }
            }
        )
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
