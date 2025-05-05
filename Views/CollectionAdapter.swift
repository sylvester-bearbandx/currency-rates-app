import UIKit

class CollectionAdapter: NSObject {
    private let collectionView: UICollectionView
    private let viewModel: CurrencyRatesViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, CurrencyRate>!

    init(collectionView: UICollectionView, viewModel: CurrencyRatesViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        configureDataSource()
        collectionView.delegate = self
    }

    private func configureDataSource() {
        collectionView.register(CurrencyRateCell.self, forCellWithReuseIdentifier: CurrencyRateCell.reuseId)

        dataSource = UICollectionViewDiffableDataSource<Int, CurrencyRate>(collectionView: collectionView) {
            [weak self] collectionView, indexPath, rate in
            guard let self = self else { return UICollectionViewCell() }

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrencyRateCell.reuseId,
                for: indexPath) as? CurrencyRateCell else {
                return UICollectionViewCell()
            }

            let isFav = self.viewModel.isFavorite(rate)
            cell.configure(with: rate, isFavorite: isFav)
            cell.delegate = self
            return cell
        }
    }

    func reload(filtered items: [CurrencyRate]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyRate>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CollectionAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension CollectionAdapter: CurrencyRateCellDelegate {
    func didTapStar(on cell: CurrencyRateCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
              let rate = dataSource.itemIdentifier(for: indexPath) else { return }

        viewModel.toggleFavorite(rate)
    }
}
