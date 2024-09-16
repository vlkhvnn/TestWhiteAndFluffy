import Foundation

protocol HomeInteractorProtocol: AnyObject {

    func fetchRandomImages() async throws -> [Photo]
    func searchImages(with query: String) async throws -> [Photo]
}

final class HomeInteractor: HomeInteractorProtocol {
    
    // MARK: - Private Properties

    private let clientId = "V8E4w_jVyCb0OJX_9VvnU2XNWIzhWwHK5SNej7lXC94"
    
    // MARK: - Internal Methods
    
    func fetchRandomImages() async throws -> [Photo] {
        let urlString = "https://api.unsplash.com/photos/random/?count=30&client_id=\(clientId)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let photos = try JSONDecoder().decode([Photo].self, from: data)
        return photos
    }
    
    func searchImages(with query: String) async throws -> [Photo] {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.unsplash.com/search/photos/?query=\(formattedQuery)&client_id=\(clientId)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(SearchPhotoModel.self, from: data)
        return searchResult.results
    }
}
