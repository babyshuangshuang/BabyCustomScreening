//
//  SceeningModel.swift
//  BabyCustomScreening
//
//  Created by 北鼻爽 on 2018/2/24.
//  Copyright © 2018年 北鼻爽. All rights reserved.
//

import UIKit

class SceeningModel: NSObject {
    
    var content = ""
    var id = 0
    var mySubList:[SceeningModel] = []
    
    func parseDic(_ dict:NSDictionary)  {
        content = dict.object(forKey: "content") as! String
    }
}


