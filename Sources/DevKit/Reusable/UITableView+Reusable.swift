#if canImport(UIKit)
import UIKit

public extension UITableView {
    
    final func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable & NibInstantiatable {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,
                                                       cellType: T.Type = T.self) -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! T
    }
    
    final func register<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: Reusable & NibInstantiatable {
        register(viewType.nib, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
    
    final func register<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: Reusable {
        register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
    
    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type = T.self) -> T where T: Reusable {
        return dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as! T
    }
}
#endif
