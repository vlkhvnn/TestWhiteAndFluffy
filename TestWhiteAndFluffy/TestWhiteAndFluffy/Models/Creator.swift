struct Creator: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case bio
        case likeCount = "total_likes"
        case photosCount = "total_photos"
    }
    
    let id: String
    let name: String
    let bio: String?
    let likeCount: Int?
    let photosCount: Int?
}
