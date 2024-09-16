import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotosCollectionViewCell"
    
    // MARK: - Private Properties
    
    private var photo: Photo?
    
    private let imageOverlay: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return overlay
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureImageOverlay()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Internal Methods
    
    func configure(with photo: Photo) {
        self.photo = photo
        guard
            let stringUrl = photo.urls["thumb"],
            let url = URL(string: stringUrl)
        else { return }
        imageView.sd_setImage(with: url)
    }
    
    // MARK: - Private Methods
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureImageOverlay() {
        contentView.addSubview(imageOverlay)
        imageOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageOverlay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
