//
// 🦠 Corona-Warn-App
//

import UIKit
import OpenCombine

final class HomeShownPositiveTestResultTableViewCell: UITableViewCell {

	// MARK: - Overrides

	override func awakeFromNib() {
		super.awakeFromNib()

		stackView.setCustomSpacing(32.0, after: topContainer)
		stackView.setCustomSpacing(32.0, after: statusContainer)
		stackView.setCustomSpacing(8.0, after: noteLabel)

		setupAccessibility()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		nextButton.titleLabel?.lineBreakMode = traitCollection.preferredContentSizeCategory >= .accessibilityMedium ? .byTruncatingMiddle : .byWordWrapping
		configureStackView()
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)

		containerView.setHighlighted(highlighted, animated: animated)
	}

	// MARK: - Internal

	func configure(with cellModel: HomeShownPositiveTestResultCellModel, onPrimaryAction: @escaping () -> Void) {
		titleLabel.text = cellModel.title
		topContainer.accessibilityLabel = cellModel.title

		statusTitleLabel.text = cellModel.statusTitle
		statusSubtitleLabel.text = cellModel.statusSubtitle
		statusFootnoteLabel.text = cellModel.statusFootnote
		statusLineView.backgroundColor = .enaColor(for: .riskHigh)

		noteLabel.text = cellModel.noteTitle

		UIView.performWithoutAnimation {
			nextButton.setTitle(cellModel.buttonTitle, for: .normal)
		}

		cellModel.$homeItemViewModels
			.receive(on: DispatchQueue.OCombine(.main))
			.sink { [weak self] in
				self?.homeItemStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

				for itemModel in $0 {
					let nibName = String(describing: itemModel.ViewType)
					let nib = UINib(nibName: nibName, bundle: .main)

					if let itemView = nib.instantiate(withOwner: self, options: nil).first as? HomeItemViewAny {
						self?.homeItemStackView.addArrangedSubview(itemView)
						itemView.configureAny(with: itemModel)
					}
				}

				self?.homeItemStackView.isHidden = $0.isEmpty
			}
			.store(in: &subscriptions)

		cellModel.$isButtonHidden
			.receive(on: DispatchQueue.OCombine(.main))
			.assign(to: \.isHidden, on: nextButton)
			.store(in: &subscriptions)

		nextButton.accessibilityIdentifier = AccessibilityIdentifiers.Home.submitCardButton

		self.onPrimaryAction = onPrimaryAction

		// Retaining cell model so it gets updated
		self.cellModel = cellModel
	}

	// MARK: - Private

	@IBOutlet private weak var titleLabel: ENALabel!

	@IBOutlet private weak var statusTitleLabel: ENALabel!
	@IBOutlet private weak var statusSubtitleLabel: ENALabel!
	@IBOutlet private weak var statusFootnoteLabel: ENALabel!
	@IBOutlet private weak var statusImageView: UIImageView!
	@IBOutlet private weak var statusLineView: UIView!

	@IBOutlet private weak var noteLabel: ENALabel!
	@IBOutlet private weak var nextButton: ENAButton!

	@IBOutlet private weak var containerView: HomeCardView!
	@IBOutlet private weak var topContainer: UIView!
	@IBOutlet private weak var statusContainer: UIView!
	@IBOutlet private weak var stackView: UIStackView!
	@IBOutlet private weak var homeItemStackView: UIStackView!

	private var subscriptions = Set<AnyCancellable>()
	private var cellModel: HomeShownPositiveTestResultCellModel?

	private var onPrimaryAction: (() -> Void)?

	@IBAction private func nextButtonTapped(_: UIButton) {
		onPrimaryAction?()
	}

	private func configureStackView() {
		if traitCollection.preferredContentSizeCategory >= .accessibilityLarge {
			statusImageView.isHidden = true
		} else {
			statusImageView.isHidden = false
		}
	}

	func setupAccessibility() {
		containerView.accessibilityElements = [topContainer as Any, statusContainer as Any, noteLabel as Any, homeItemStackView as Any, nextButton as Any]

		topContainer.isAccessibilityElement = true
		topContainer.accessibilityTraits = [.button, .header]
	}

}
