import Foundation

struct Photo: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case urls
        case description
        case altDescription = "alt_description"
        case creator = "user"
        case views
        case downloads
        case createdAt = "created_at"
        case location
    }
    
    let id: String
    let urls: [String: String]
    let description: String?
    let altDescription: String?
    let creator: Creator
    let views: Int?
    let downloads: Int?
    let createdAt: String?
    let location: Location?
    
    func formattedCreatedAt() -> Date? {
        guard let createdAt = createdAt else { return nil }
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: createdAt)
    }
}

extension Photo {
    
    struct Location: Decodable {
        
        struct Position: Decodable {
            
            let latitude: Double?
            let longitude: Double?
        }
        
        let name: String?
        let city: String?
        let country: String?
        let position: Position?
    }
}
