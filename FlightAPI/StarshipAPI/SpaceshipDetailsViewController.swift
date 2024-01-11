import UIKit

class SpaceshipDetailsViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var crewAmount: UILabel!
    @IBOutlet var passengerAmount: UILabel!
    @IBOutlet var hyperdriveRating: UILabel!
    @IBOutlet var length: UILabel!
    @IBOutlet var Manufacturer: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    
    var spaceship: Starship?
    var starshipImage: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded SpaceshipDetailsViewController with spaceship: \(String(describing: spaceship?.name))")

        nameLabel.text = spaceship?.name
        costLabel.text = spaceship?.cost_in_credits
        crewAmount.text = spaceship?.crew
        passengerAmount.text = spaceship?.passengers
        hyperdriveRating.text = spaceship?.hyperdrive_rating
        length.text = spaceship?.length
        Manufacturer.text = spaceship?.manufacturer
        if let starshipImage = starshipImage {
            imageView.image = starshipImage
            imageView.contentMode = .scaleAspectFit

        }
    }
}
