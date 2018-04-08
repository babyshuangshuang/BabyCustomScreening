//
//  ViewController.swift
//  BabyCustomScreening
//
//  Created by 北鼻爽 on 2018/2/24.
//  Copyright © 2018年 北鼻爽. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let screeningView = ScreeningView(frame: CGRect(x: 0, y: 100, width: kScreenWidth, height: 40), sectionNum: 3)
        
        let arr = ["1-1","1-2","1-3","1-4","1-5"]
        let mo1 = SceeningModel()
        mo1.content = "第一组"
        for str in arr {
            let model = SceeningModel()
            model.content = str
            for str1 in arr {
                let model1 = SceeningModel()
                model1.content = str1
                model.mySubList.append(model1)
            }
            mo1.mySubList.append(model)
        }
        
        let arr1 = ["2-1","2-2","2-3","2-4","2-5"]
        let mo2 = SceeningModel()
        mo2.content = "第二组"
        for str in arr1 {
            let model = SceeningModel()
            model.content = str
            mo2.mySubList.append(model)
        }
        
        let arr2 = ["3-1","3-2","3-3","3-4","3-5"]
        let mo3 = SceeningModel()
        mo3.content = "第三组"
        for str in arr2 {
            let model = SceeningModel()
            model.content = str
            mo3.mySubList.append(model)
        }

        screeningView.dataArr = [mo1,mo2,mo3]
        self.view.addSubview(screeningView)
        //点击每一行的回调，section是哪一组，model是所选行的数据，row为所选行
        screeningView.block = {
            [weak self] section ,model, row in
            print("section=",section,"model=",model,"row=",row)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

