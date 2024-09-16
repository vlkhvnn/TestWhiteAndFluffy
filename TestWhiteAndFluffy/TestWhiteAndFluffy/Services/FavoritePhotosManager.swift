final class FavoritePhotosManager {
    
    // MARK: - Properties

    static let shared = FavoritePhotosManager()
    
    private(set) var favoritePhotos = [Photo]()
    
    // MARK: - Initializer

    private init() {}
    
    // MARK: - Internal Methods

    func addPhotoToFavorites(_ photo: Photo) {
        guard !favoritePhotos.contains(where: { $0.id == photo.id }) else { return }
        favoritePhotos.append(photo)
    }

    func removePhotoFromFavorites(_ photo: Photo) {
        favoritePhotos.removeAll { $0.id == photo.id }
    }

    func isFavorite(_ photo: Photo) -> Bool {
        return favoritePhotos.contains(where: { $0.id == photo.id })
    }
    
    func getFavorites() -> [Photo] {
        favoritePhotos
    }
}
