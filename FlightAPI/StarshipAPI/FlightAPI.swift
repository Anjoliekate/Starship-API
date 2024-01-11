import Foundation

enum EndPoint: String {
    case starships
}

struct FlightAPI {
    private static let baseURLString = "https://swapi.dev/api"
    
    static func URL(endPoint: EndPoint, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: "\(baseURLString)/\(endPoint.rawValue)")!
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func starships(fromJSON data: Data) -> Result<[Starship], Error> {
        do {
            let decoder = JSONDecoder()
            let starshipResponse = try decoder.decode(StarshipResponse.self, from: data)
            return .success(starshipResponse.starships)
        } catch {
            return .failure(error)
        }
    }
}

struct StarshipResponse: Codable {
    let starships: [Starship]
    
    enum CodingKeys: String, CodingKey {
        case starships = "results"
    }
}
