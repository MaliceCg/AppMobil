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
    @State private var currentPage = "inscription"
  
    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            
            Text("Veuillez choisir le poste où vous souhaitez vous inscrire : ")
              .font(.system (size:20))
              .frame(maxWidth: .infinity, alignment: .center)
            Text("Je suis Inscription")
                .navigationBarBackButtonHidden(true)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

