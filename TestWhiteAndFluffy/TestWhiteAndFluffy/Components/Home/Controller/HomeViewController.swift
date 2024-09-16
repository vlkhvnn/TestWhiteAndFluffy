import UIKit
import SDWebImage

final class HomeViewController: UIViewController,
                                UISearchBarDelegate,
                                UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    // MARK: - Internal Properties
    
    var interactor: HomeInteractorProtocol?
    
    // MARK: - Private Properties
    
    private var expand = false
    private var search = ""
    private var randomImages = [Photo]()
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    // MARK: - Views
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let newCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return newCollectionView
    }()
    
    private let searchBar = UISearchBar()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Unsplash"
        title.font = UIFont.boldSystemFont(ofSize: 24)
        return title
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Beautiful, Free Photos"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        return subtitleLabel
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(toggleSearch), for: .touchUpInside)
        button.tintColor = .gray
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(toggleSearch), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        loadRandomImages()
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        configureTopStackView()
        configureTableView()
        configureSearchBar()
    }
    
    private func configureTopStackView() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        [titleStackView, searchBar, searchButton, closeButton].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        view.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureTableView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier
        )
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.isHidden = true
        searchBar.placeholder = "Search..."
    }
    
    @objc func toggleSearch() {
        expand.toggle()
        searchBar.isHidden = !expand
        closeButton.isHidden = !expand
        searchButton.isHidden = expand
        titleStackView.isHidden = expand
        if !expand {
            loadRandomImages()
        }
    }
    
    // MARK: - Data Loading

    private func loadRandomImages() {
        Task {
            do {
                let photos = try await interactor?.fetchRandomImages()
                guard let photos else { return }
                randomImages = photos
                collectionView.reloadData()
            } catch {
                showErrorAlert(message: "Failed to load data: \(error.localizedDescription)")
            }
        }
    }
    
    private func searchImages() {
        Task {
            do {
                let photos = try await interactor?.searchImages(with: search)
                randomImages = photos ?? []
                collectionView.reloadData()
            } catch {
                showErrorAlert(message: "Failed to load search results: \(error.localizedDescription)")
            }
        }
    }
        
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - SearchBar Delegate

extension HomeViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search = searchBar.text ?? ""
        searchImages()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotosCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotosCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: randomImages[indexPath.row])
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoInfoViewController()
        vc.apply(photo: randomImages[indexPath.row])
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + 12
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
