
// ContentView.swift
import SwiftUI

struct ContentView: View {
    @ObservedObject var RegisViewModel = RegisterViewModel()
    @ObservedObject var LogViewModel = LoginViewModel()
    
  
    var body: some View {
        NavigationView {
        VStack(spacing: 20) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            Text("Bienvenue au Festival du Jeu de Montpellier")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text("Pour pouvoir participer à l'organisation et t'inscrire à des postes, crée toi un compte.")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            NavigationLink(destination: RegisterView(viewModel: RegisViewModel)) {
                Text("S'inscrire")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        
            NavigationLink(destination: LoginView(viewModel: LogViewModel)) {
                Text("Se connecter")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
