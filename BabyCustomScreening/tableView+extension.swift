//
//  tableView+extension.swift
//  BabyCustomScreening
//
//  Created by 北鼻爽 on 2018/2/26.
//  Copyright © 2018年 北鼻爽. All rights reserved.
//

import Foundation
import UIKit

fileprivate var FMprojectKey: [SceeningModel] = []

extension UITableView {
    
    var customDataSourse: [SceeningModel]  {
        set {
            objc_setAssociatedObject(self, &FMprojectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &FMprojectKey) as? [SceeningModel] {
                return rs
            }
            return []
        }
    }
    
}
