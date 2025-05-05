import UIKit

class CurrencyRatesViewController: UIViewController {
    private let viewModel: CurrencyRatesViewModel
    private var collectionView: UICollectionView!
    private var adapter: CollectionAdapter!
    private let isFavoritesOnly: Bool
    private var autoRefreshTimer: Timer?

    private let refreshControl = UIRefreshControl()

    private let offlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Offline Mode"
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    init(viewModel: CurrencyRatesViewModel, isFavoritesOnly: Bool = false) {
        self.viewModel = viewModel
        self.isFavoritesOnly = isFavoritesOnly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = isFavoritesOnly ? "Favorites" : "Exchange Rates"
        view.backgroundColor = .systemBackground

        setupUI()
        configureCollectionView()

        adapter = CollectionAdapter(collectionView: collectionView, viewModel: viewModel)

        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }

            self.offlineLabel.isHidden = !self.viewModel.isOffline

            if let date = self.viewModel.lastUpdated {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                self.lastUpdatedLabel.text = "Last updated: \(formatter.string(from: date))"
            } else {
                self.lastUpdatedLabel.text = nil
            }

            let data = self.isFavoritesOnly
                ? self.viewModel.favorites.sorted { $0.code < $1.code }
                : self.viewModel.rates

            self.adapter.reload(filtered: data)
            self.refreshControl.endRefreshing() // ✅ Останавливаем индикатор
        }

        viewModel.fetchRates()

        autoRefreshTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.viewModel.fetchRates()
        }
    }

    private func setupUI() {
        view.addSubview(offlineLabel)
        view.addSubview(lastUpdatedLabel)

        offlineLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            offlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            offlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineLabel.heightAnchor.constraint(equalToConstant: 30),

            lastUpdatedLabel.topAnchor.constraint(equalTo: offlineLabel.bottomAnchor),
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lastUpdatedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lastUpdatedLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(60)
                )
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(60)
                ),
                subitems: [item]
            )
            return NSCollectionLayoutSection(group: group)
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lastUpdatedLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func refreshTriggered() {
        viewModel.fetchRates()
    }
}
