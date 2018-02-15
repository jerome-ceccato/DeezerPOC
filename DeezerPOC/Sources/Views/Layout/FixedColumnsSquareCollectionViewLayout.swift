//
//  FixedColumnsCollectionViewLayout.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit

// A collectionView layout with a fixed number of columns
class FixedColumnsSquareCollectionViewLayout: UICollectionViewFlowLayout {
    @IBInspectable var columnsCount: Int = 3
    
    override var itemSize: CGSize {
        get {
            return calculateItemSize()
        }
        set {
            // Always precalculated to fit the available width
        }
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else {
            return context
        }

        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = newBounds != collectionView?.bounds
        return context
    }
    
    private func calculateItemSize() -> CGSize {
        guard let currentWidth = collectionView?.bounds.width else {
            return .zero
        }
        
        let insets = sectionInset.left + sectionInset.right
        let spacing = minimumInteritemSpacing * (CGFloat(columnsCount) - 1)
        let itemsTotalWidth = currentWidth - (insets + spacing)
        let itemWidth = (itemsTotalWidth / CGFloat(columnsCount)).rounded(.down)

        return CGSize(width: itemWidth, height: itemWidth)
    }
}
