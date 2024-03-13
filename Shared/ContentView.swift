// ContentView.swift
import SwiftUI


struct ContentView: View {
    // Ajoutez cette ligne pour initialiser LoginViewModel
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        // Modifiez cette ligne pour passer viewModel à LoginView
        LoginView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
