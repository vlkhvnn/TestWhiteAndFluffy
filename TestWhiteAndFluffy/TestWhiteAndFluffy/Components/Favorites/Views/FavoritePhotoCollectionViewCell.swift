import UIKit
import SDWebImage

final class FavoritePhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoritePhotoCollectionViewCell"
    
    // MARK: - Private Properties

    private let imageView = UIImageView()
    private let authorLabel = UILabel()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureAuthorLabel()
        setupLayout()
        applyShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods

    func configure(with photo: Photo) {
        if let imageUrlString = photo.urls["regular"], let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        authorLabel.text = "Author: \(photo.creator.name)"
    }
    
    // MARK: - Private Methods

    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        addSubview(imageView)
    }

    private func configureAuthorLabel() {
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        authorLabel.textColor = .gray
        authorLabel.textAlignment = .center
        addSubview(authorLabel)
    }

    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),

            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func applyShadow() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}
