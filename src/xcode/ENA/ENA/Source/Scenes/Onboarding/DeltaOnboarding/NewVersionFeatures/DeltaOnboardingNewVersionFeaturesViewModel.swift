//
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

struct DeltaOnboardingNewVersionFeaturesViewModel {
	
	// MARK: - Init

	init() {
		
		// ADD NEW FEATURES HERE
		
		self.featureVersion = "2.1"
		
		// Antigen Registration
		self.newVersionFeatures.append(
			NewVersionFeature(title: AppStrings.NewVersionFeatures.feature21RegAntigenTitle, description: AppStrings.NewVersionFeatures.feature21RegAntigenDescription)
		)
		
		// Show proof
		self.newVersionFeatures.append(
			NewVersionFeature(title: AppStrings.NewVersionFeatures.feature21ShowProofTitle, description: AppStrings.NewVersionFeatures.feature21ShowProofDescription)
		)
		
		// New international tech hotline
		self.newVersionFeatures.append(
			NewVersionFeature(title: AppStrings.NewVersionFeatures.feature21NewIntTechHotlineTitle, description: AppStrings.NewVersionFeatures.feature21NewIntTechHotlineDescription)
		)
		
		// New international tan hotline
		self.newVersionFeatures.append(
			NewVersionFeature(title: AppStrings.NewVersionFeatures.feature21NewIntTanHotlineTitle, description: AppStrings.NewVersionFeatures.feature21NewIntTanHotlineDescription)
		)
		
	}

	// MARK: - Internal
	
	let featureVersion: String

	var dynamicTableViewModel: DynamicTableViewModel {
		DynamicTableViewModel.with {
			$0.add(
				.section(
					cells: [
						.subheadline(text: "\(AppStrings.NewVersionFeatures.release) \(self.featureVersion)",
									 color: UIColor.enaColor(for: .textPrimary1), accessibilityIdentifier: AccessibilityIdentifiers.DeltaOnboarding.newVersionFeaturesVersionInfo)
					]
				)
			)
			$0.add(
				.section(
					header: .image(
						UIImage(named: "Illu_NewVersion_Features"),
						accessibilityLabel: AppStrings.NewVersionFeatures.accImageLabel,
						accessibilityIdentifier: AccessibilityIdentifiers.DeltaOnboarding.newVersionFeaturesAccImageDescription,
						height: 250
					),
					cells: [
						.subheadline(text: AppStrings.NewVersionFeatures.generalDescription, color: UIColor.enaColor(for: .textPrimary2), accessibilityIdentifier: AccessibilityIdentifiers.DeltaOnboarding.newVersionFeaturesGeneralDescription)
					]
				)
			)
			$0.add(
				.section(
					separators: .none,
					cells: buildNewFeaturesCells()
				)
			)
			$0.add(
				.section(
					cells: [
						.body(text: AppStrings.NewVersionFeatures.aboutAppInformation,
							  color: .enaColor(for: .textPrimary1),
							  accessibilityIdentifier: AccessibilityIdentifiers.DeltaOnboarding.newVersionFeaturesGeneralAboutAppInformation)
					]
				)
			)
		}
	}

	// MARK: - Private
	
	private var newVersionFeatures: [NewVersionFeature] = []
	
	private func buildNewFeaturesCells() -> [DynamicCell] {
		var cells: [DynamicCell] = []
		let boldTextAttribute: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.enaFont(for: .body, weight: .bold)
		]
		let normalTextAttribute: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.enaFont(for: .body)
		]
		
		for feature in newVersionFeatures {
			let featureBulletPoint = NSMutableAttributedString(string: feature.title + "\n\t", attributes: boldTextAttribute)
			featureBulletPoint.append(NSAttributedString(string: feature.description, attributes: normalTextAttribute))
			featureBulletPoint.append(NSAttributedString(string: "\n", attributes: normalTextAttribute))
			cells.append(.bulletPoint(attributedText: featureBulletPoint))
		}
		return cells
	}
}
