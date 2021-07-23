#if canImport(UIKit)
import UIKit

public extension UICollectionView {
    
    final func register<T: UICollectionViewCell>(cellType: T.Type) where T: Reusable & NibInstantiatable {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UICollectionViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath,
                                                            cellType: T.Type = T.self) -> T where T: Reusable {
        return dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as! T
    }
    
    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type,
                                                     ofKind elementKind: String) where T: Reusable & NibInstantiatable {
        register(supplementaryViewType.nib,
                 forSupplementaryViewOfKind: elementKind,
                 withReuseIdentifier: supplementaryViewType.reuseIdentifier)
    }
    
    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type,
                                                     ofKind elementKind: String) where T: Reusable {
        register(supplementaryViewType.self,
                 forSupplementaryViewOfKind: elementKind,
                 withReuseIdentifier: supplementaryViewType.reuseIdentifier)
    }
    
    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String,
                                                                             for indexPath: IndexPath,
                                                                             viewType: T.Type = T.self) -> T where T: Reusable {
        return dequeueReusableSupplementaryView(ofKind: elementKind,
                                                withReuseIdentifier: viewType.reuseIdentifier,
                                                for: indexPath) as! T
    }
}
#endif
