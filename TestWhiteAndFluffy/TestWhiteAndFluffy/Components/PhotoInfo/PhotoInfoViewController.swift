import UIKit
import SDWebImage

final class PhotoInfoViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var isFavorite: Bool = false
    private var currentPhoto: Photo?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let creatorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let viewsLabel = UILabel()
    private let downloadsLabel = UILabel()
    private let createdAtLabel = UILabel()
    private let locationLabel = UILabel()
    private let positionLabel = UILabel()
    private let favoriteView = UIView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Internal Methods
    
    func apply(photo: Photo) {
        self.currentPhoto = photo
        if let imageUrlString = photo.urls["regular"], let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        }
        
        creatorLabel.text = "By: \(photo.creator.name)"
        descriptionLabel.text = photo.description ?? photo.altDescription ?? "No description available"
        viewsLabel.text = "Views: \(photo.views ?? 0)"
        downloadsLabel.text = "Downloads: \(photo.downloads ?? 0)"
        applyDate(date: photo.formattedCreatedAt())
        applyLocation(location: photo.location)
        isFavorite = FavoritePhotosManager.shared.isFavorite(photo)
        updateFavoriteView()
    }
    
    // MARK: - Private Methods

    private func configureView() {
        view.backgroundColor = .white
        configureScrollView()
        configureImageView()
        configureCreatorLabel()
        configureDescriptionLabel()
        configureViewsLabel()
        configureDownloadsLabel()
        configureCreatedAtLabel()
        configureLocationLabel()
        configurePositionLabel()
        configureFavoriteView()
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    private func configureCreatorLabel() {
        creatorLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorLabel.font = UIFont.boldSystemFont(ofSize: 18)
        creatorLabel.numberOfLines = 0
        creatorLabel.textAlignment = .center
        contentView.addSubview(creatorLabel)
        NSLayoutConstraint.activate([
            creatorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            creatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureViewsLabel() {
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.font = UIFont.systemFont(ofSize: 18)
        viewsLabel.numberOfLines = 0
        contentView.addSubview(viewsLabel)
        NSLayoutConstraint.activate([
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCreatedAtLabel() {
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.font = UIFont.systemFont(ofSize: 18)
        createdAtLabel.numberOfLines = 0
        contentView.addSubview(createdAtLabel)
        NSLayoutConstraint.activate([
            createdAtLabel.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 8),
            createdAtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createdAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLocationLabel() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.systemFont(ofSize: 18)
        locationLabel.numberOfLines = 0
        contentView.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configurePositionLabel() {
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.font = UIFont.systemFont(ofSize: 18)
        positionLabel.numberOfLines = 0
        contentView.addSubview(positionLabel)
        NSLayoutConstraint.activate([
            positionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            positionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            positionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            positionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureDownloadsLabel() {
        downloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadsLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(downloadsLabel)
        NSLayoutConstraint.activate([
            downloadsLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 8),
            downloadsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            downloadsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    private func configureFavoriteView() {
        favoriteView.translatesAutoresizingMaskIntoConstraints = false
        favoriteView.backgroundColor = .white
        favoriteView.layer.cornerRadius = 18
        favoriteView.layer.shadowColor = UIColor.black.cgColor
        favoriteView.layer.shadowOpacity = 0.2
        favoriteView.layer.shadowOffset = CGSize(width: 0, height: 2)
        favoriteView.layer.shadowRadius = 4
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteViewTapped))
        favoriteView.addGestureRecognizer(tapGestureRecognizer)
        favoriteView.isUserInteractionEnabled = true
        
        contentView.addSubview(favoriteView)
        NSLayoutConstraint.activate([
            favoriteView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            favoriteView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            favoriteView.heightAnchor.constraint(equalToConstant: 36),
            favoriteView.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        updateFavoriteView()
    }
    
    private func updateFavoriteView() {
        favoriteView.subviews.forEach { $0.removeFromSuperview() }
        let heartImageView = UIImageView()
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        heartImageView.tintColor = isFavorite ? .red : .gray
        
        favoriteView.addSubview(heartImageView)
        NSLayoutConstraint.activate([
            heartImageView.centerXAnchor.constraint(equalTo: favoriteView.centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor),
            heartImageView.heightAnchor.constraint(equalToConstant: 24),
            heartImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func applyDate(date: Date?) {
        guard let date else {
            createdAtLabel.text = "Created at: N/A"
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        createdAtLabel.text = "Created at: \(dateFormatter.string(from: date))"
    }
    
    private func applyLocation(location: Photo.Location?) {
        guard
            let location,
            let name = location.name,
            let city = location.city,
            let country = location.country,
            let position = location.position
        else {
            locationLabel.text = "Location: N/A"
            positionLabel.text = "Coordinates: N/A"
            return
        }
        
        locationLabel.text = "Location: \(name), \(city), \(country)"
        positionLabel.text = "Coordinates: Lat \(position.latitude ?? 0), Long \(position.longitude ?? 0)"
    }
    
    @objc
    private func favoriteViewTapped() {
        guard let photo = currentPhoto else { return }

        if isFavorite {
            let alert = UIAlertController(
                title: "Remove Favorite",
                message: "Are you sure you want to remove this photo from your favorites?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
                FavoritePhotosManager.shared.removePhotoFromFavorites(photo)
                self?.isFavorite = false
                self?.updateFavoriteView()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            FavoritePhotosManager.shared.addPhotoToFavorites(photo)
            isFavorite = true
            updateFavoriteView()
        }
    }

}
