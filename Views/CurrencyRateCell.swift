import UIKit

protocol CurrencyRateCellDelegate: AnyObject {
    func didTapStar(on cell: CurrencyRateCell)
}

class CurrencyRateCell: UICollectionViewCell {
    static let reuseId = "CurrencyRateCell"

    private let label = UILabel()
    private let star = UIImageView()

    weak var delegate: CurrencyRateCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        label.font = .systemFont(ofSize: 17, weight: .medium)

        star.tintColor = .systemYellow
        star.contentMode = .scaleAspectFit
        star.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(starTapped))
        star.addGestureRecognizer(tap)

        contentView.addSubview(label)
        contentView.addSubview(star)

        label.translatesAutoresizingMaskIntoConstraints = false
        star.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            star.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            star.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            star.widthAnchor.constraint(equalToConstant: 20),
            star.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var isFavorite: Bool = false

    func configure(with rate: CurrencyRate, isFavorite: Bool) {
        label.text = "\(rate.code): \(String(format: "%.2f", rate.rate))"
        self.isFavorite = isFavorite

        let imageName = isFavorite ? "star.fill" : "star"
        star.image = UIImage(systemName: imageName)
    }

    @objc private func starTapped() {
        isFavorite.toggle()
        let imageName = isFavorite ? "star.fill" : "star"
        star.image = UIImage(systemName: imageName)
        animateStar()
        delegate?.didTapStar(on: self)
    }

    private func animateStar() {
        star.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 2,
                       options: .curveEaseInOut,
                       animations: {
            self.star.transform = .identity
        })
    }
}
