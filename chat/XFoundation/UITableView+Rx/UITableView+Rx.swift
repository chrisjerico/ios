//
//  UITableView+Rx.swift
//  chat
//
//  Created by xionghx on 2020/5/27.
//  Copyright © 2020 ug. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITableView {
	
	
	/**
	  Reactive wrapper for `delegate` message `tableView:commitEditingStyle:forRowAtIndexPath:`.
	  */
//	  public var itemDeleted: ControlEvent<IndexPath> {
//		  let source = self.dataSource.methodInvoked(#selector(UITableViewDataSource.tableView(_:commit:forRowAt:)))
//			  .filter { a in
//				  return UITableViewCell.EditingStyle(rawValue: (try castOrThrow(NSNumber.self, a[1])).intValue) == .delete
//			  }
//			  .map { a in
//				  return try castOrThrow(IndexPath.self, a[2])
//			  }
//
//		  return ControlEvent(events: source)
//	  }
	
	
}

