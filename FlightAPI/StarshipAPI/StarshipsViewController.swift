import Foundation
import UIKit

class StarshipStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func processStarshipsRequest(data: Data?, error: Error?) -> Result<[Starship], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlightAPI.starships(fromJSON: jsonData)
    }
    
    func fetchStarships(completion: @escaping (Result<[Starship], Error>) -> Void) {
        let url = FlightAPI.URL(endPoint: .starships, parameters: nil)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processStarshipsRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
}

class StarshipsViewController: UITableViewController {
    var starshipStore = StarshipStore()
    var starships = [Starship]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starshipStore.fetchStarships { [weak self] (result) in
            switch result {
            case .success(let fetchedStarships):
                self?.starships = fetchedStarships
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_): break
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of starships: \(starships.count)")
        return starships.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarshipCell", for: indexPath) as! StarshipCell
        let starship = starships[indexPath.row]
        cell.starshipLabel.text = starship.name
        cell.costLabel.text = starship.cost_in_credits
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    let starshipImages: [UIImage?] = [
        UIImage(named: "CR90-Corvette"),
        UIImage(named: "Star-Destroyer"),
        UIImage(named: "Sentinel-Class"),
        UIImage(named: "Death-Star"),
        UIImage(named: "Millenium-Falcon"),
        UIImage(named: "Y-wing"),
        UIImage(named: "X-Wing"),
        UIImage(named: "TIE-Advanced"),
        UIImage(named: "Executor"),
        UIImage(named: "Rebel-Transport")
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSpaceshipDetails",
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let spaceshipDetailsViewController = segue.destination as? SpaceshipDetailsViewController {
            let starship = starships[indexPath.row]
            let starshipImage = starshipImages[indexPath.row]
            print("Preparing for segue with spaceship: \(starship)")
            spaceshipDetailsViewController.spaceship = starship
            spaceshipDetailsViewController.starshipImage = starshipImage
        }
    }
    
}
    

