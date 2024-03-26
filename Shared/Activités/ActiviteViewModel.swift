import Foundation
import Combine

class ActiviteViewModel: ObservableObject {
    @Published var idFestival: FestivalID
    @Published var state: ActiviteState = ActiviteState()
    private var activiteIntent: ActiviteIntent?
    private var cancellables = Set<AnyCancellable>()

    init(idFestival: FestivalID) {
        self.idFestival = idFestival
        send(intent: .fetchPostes)
    }

    func send(intent: ActiviteIntent) {
        self.activiteIntent = intent

        switch intent {
        case .fetchPostes:
            fetchPostes()
        case .fetchInscription:
            fetchInscription()
        case .unsubscribe(_, _, _, _):
            unsubscribe()
            
        }
    }

    private func fetchPostes() {
        print("Fetching posts...")
        guard let url = URL(string: "https://awi-api-2.onrender.com/employer-module/festival/\(idFestival.id)") else {
            print("URL invalide")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Erreur lors de la récupération des données : \(error)")
                return
            }

            guard let data = data else {
                print("Pas de données reçues")
                return
            }

            do {
                let decodedPostes = try JSONDecoder().decode([Employer].self, from: data)
                DispatchQueue.main.async {
                    self.state.postes = decodedPostes
                    self.state.loading = false
                    self.send(intent: .fetchInscription)
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }

        task.resume()
    }

    private func fetchInscription() {
        print("Fetching inscriptions...")
        guard let userId = UserDefaults.standard.string(forKey: "id") else {
            print("User ID non trouvé")
            return
        }
        print(userId)
        guard let url = URL(string: "https://awi-api-2.onrender.com/inscription-module/volunteer/\(userId)") else {
            print("URL invalide")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Erreur lors de la récupération des données : \(error)")
                return
            }

            guard let data = data else {
                print("Pas de données reçues")
                return
            }

            do {
                let decodedInscriptions = try JSONDecoder().decode([Inscription].self, from: data)
                let filteredInscriptions = decodedInscriptions.filter { inscription in
                    self.state.postes.contains { poste in
                        poste.idPoste == inscription.idPoste
                    }
                }

                // Fetch post details for each inscription
                var posts = [Position]()
                var zones = [Zone]() // Nouvel état pour stocker les zones
                var referentRelations = [RefRelation]() // Nouvel état pour stocker les relations référents-postes
                for inscription in filteredInscriptions {
                    let postUrl = URL(string: "https://awi-api-2.onrender.com/position-module/\(inscription.idPoste)")!
                    let postTask = URLSession.shared.dataTask(with: postUrl) { (postData, postResponse, postError) in
                        if let postError = postError {
                            print("Error fetching post details: \(postError)")
                            return
                        }

                        guard let postData = postData else {
                            print("No post data received")
                            return
                        }

                        do {
                            let decodedPost = try JSONDecoder().decode(Position.self, from: postData)
                            DispatchQueue.main.async {
                                posts.append(decodedPost)
                                self.state.posts = posts // Mettez à jour state.posts ici
                                print(self.state.posts)
                            }

                            // Fetch zone details for each inscription
                            let zoneUrl = URL(string: "https://awi-api-2.onrender.com/volunteer-area-module/\(inscription.idZoneBenevole)")!
                            let zoneTask = URLSession.shared.dataTask(with: zoneUrl) { (zoneData, zoneResponse, zoneError) in
                                if let zoneError = zoneError {
                                    print("Error fetching zone details: \(zoneError)")
                                    return
                                }

                                guard let zoneData = zoneData else {
                                    print("No zone data received")
                                    return
                                }

                                do {
                                    let decodedZone = try JSONDecoder().decode(Zone.self, from: zoneData)
                                    DispatchQueue.main.async {
                                        zones.append(decodedZone)
                                        self.state.zones = zones // Mettez à jour state.zones ici
                                        print(self.state.zones)
                                    }
                                } catch {
                                    print("Error decoding zone data: \(error)")
                                }
                            }
                            zoneTask.resume()

                            // Fetch referent relations for each post
                            let referentRelationUrl = URL(string: "https://awi-api-2.onrender.com/referent-module/position/\(inscription.idPoste)")!
                            let referentRelationTask = URLSession.shared.dataTask(with: referentRelationUrl) { (referentRelationData, referentRelationResponse, referentRelationError) in
                                if let referentRelationError = referentRelationError {
                                    print("Error fetching referent relations: \(referentRelationError)")
                                    return
                                }

                                guard let referentRelationData = referentRelationData else {
                                    print("No referent relation data received")
                                    return
                                }

                                do {
                                    let decodedReferentRelations = try JSONDecoder().decode([RefRelation].self, from: referentRelationData)
                                    DispatchQueue.main.async {
                                        referentRelations.append(contentsOf: decodedReferentRelations)
                                        self.state.referentRelation = referentRelations // Mettez à jour state.referentRelation ici
                                        print(self.state.referentRelation)
                                    }
                                } catch {
                                    print("Error decoding referent relation data: \(error)")
                                }
                            }
                            referentRelationTask.resume()
                        } catch {
                            print("Error decoding post data: \(error)")
                        }
                    }
                    postTask.resume()
                }

                DispatchQueue.main.async {
                    self.state.inscription = filteredInscriptions
                    self.state.loading = false
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }

        task.resume()
    }

 func fetchReferentDetails(benevoleId: Int, completion: @escaping (User?) -> Void) {
        guard let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/\(benevoleId)") else {
            print("URL invalide")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Erreur lors de la récupération des données : \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Pas de données reçues")
                completion(nil)
                return
            }

            do {
                let decodedReferent = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedReferent)
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
                completion(nil)
            }
        }

        task.resume()
    }


    private func unsubscribe() {}
}
