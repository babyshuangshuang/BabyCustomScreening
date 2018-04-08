//
//  ScreeningView.swift
//  BabyCustomScreening
//
//  Created by 北鼻爽 on 2018/2/24.
//  Copyright © 2018年 北鼻爽. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let isIphoneX = kScreenHeight == 812 ? true : false
let kNavBarHeight:CGFloat = isIphoneX == true ? 88.5 : 64.5
let gDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!


class ScreeningView: UIView ,UITableViewDelegate, UITableViewDataSource{
    typealias stringBlock = (SceeningModel) -> ()
    typealias chooseRowBlock = (Int,SceeningModel,Int) -> ()
    typealias closureButtonToVoid = (UIButton) -> ()

    fileprivate var sectionNum = 0
    
    var dataArr:[SceeningModel] = []{
        didSet{
            if  dataArr.count == sectionNum{
                if dataArr.count > 0 {
                    mainTable.customDataSourse = dataArr[currentTable].mySubList
                    mainTable.reloadData()
                }
                for i in 0..<titleBtnArr.count {
                    titleBtnArr[i].setTitle(dataArr[i].content, for: .normal)
                    titleBtnArr[i].imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: CGFloat(-(dataArr[i].content.count * 30)))
                    titleBtnArr[i].titleEdgeInsets = .init(top: 0, left: -30, bottom: 0, right: 0)
                }
            }
        }
    }
    
    var titleColor:UIColor = .lightGray //标题文字的颜色
    var titleBackColor:UIColor = .white   //标题背景色
    var titleFont:UIFont = .systemFont(ofSize: 14)
    var titleBtnArr:[UIButton] = []
    var mainTable = UITableView()
    var tableArr:[UITableView] = []
    fileprivate var chooseRow: [Int] = []  //多个table的时候每个table选中的行数
    var currentTable = 0 //当前展示的table是第几个按钮展开的
    
    var block: chooseRowBlock?
    var clickBtnBlock: closureButtonToVoid?
    
    var currentBtn = UIButton()
    init(frame: CGRect, sectionNum: Int) {
        super.init(frame: frame)
        self.sectionNum = sectionNum
        for i in 0..<sectionNum {
            let btn = UIButton(frame: CGRect(x:i * Int(kScreenWidth) / sectionNum, y: 0, width: Int(kScreenWidth) / sectionNum, height: 39))
            btn.setTitleColor(titleColor, for: .normal)
            btn.backgroundColor = titleBackColor
            btn.setImage(UIImage(named: "下拉"), for: .normal)
            btn.setImage(UIImage(named: "上拉"), for: .selected)
            btn.titleLabel?.font = titleFont
            btn.setTitle("全部", for: UIControlState.normal)
            btn.tag = i
            self.addSubview(btn)
            titleBtnArr.append(btn)
            btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        }

        setUpSubviews()
    }

    
    deinit {
        clickScreenGrayView()
    }
    func setUpSubviews() {
        
        mainTable = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300), style: .plain)

        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.rowHeight = 40
        mainTable.tag = 0
        mainTable.separatorStyle = .none
        mainTable.tableFooterView = UIView()
        self.screenGrayView.addSubview(mainTable)
        mainTable.isHidden = true
        screenGrayView.isHidden = true
        tableArr.append(mainTable)
    }
    
    @objc func clickBtn(sender:UIButton) {
        gDelegate.window?.bringSubview(toFront:screenGrayView)
        for btn in titleBtnArr {
            if btn != sender{
                btn.isSelected = false
            }
        }
        sender.isSelected = !sender.isSelected
        currentBtn = sender
        print(sender.tag)
        if sender.isSelected {
            mainTable.isHidden = false
            screenGrayView.isHidden = false
            mainTable.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 300)

        }else{
            mainTable.isHidden = true
            screenGrayView.isHidden = true
        }
        currentTable = sender.tag
        if currentTable >= dataArr.count {
            return
        }
        mainTable.customDataSourse = dataArr[currentTable].mySubList
        mainTable.reloadData()
        for i in 1..<tableArr.count {
            tableArr[i].removeFromSuperview()
        }
        tableArr.removeAll()
        tableArr.append(mainTable)
        clickBtnBlock?(sender)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.customDataSourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "123")
        cell.textLabel?.text = tableView.customDataSourse[indexPath.row].content
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = titleFont
        cell.textLabel?.textColor = titleColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.customDataSourse[indexPath.row].mySubList.count > 0 {
            if tableView.tag < tableArr.count - 1 {
                var tempTableArr:[UITableView] = []
                for i in 0..<tableArr.count {
                    if i <= tableView.tag + 1{
                        if i == tableView.tag + 1{
                            tableArr[i].customDataSourse = tableView.customDataSourse[indexPath.row].mySubList
                            tableArr[i].reloadData()
                            chooseRow.remove(at: i-1)
                            chooseRow.insert(indexPath.row, at: i-1)
                        }
                        tempTableArr.append(tableArr[i])
                    }else{
                        for j in tempTableArr {
                            if tableArr[i] != j {
                                tableArr[i].removeFromSuperview()
                            }
                        }
                    }
                }
                tableArr = tempTableArr
                
            }else{
                chooseRow.insert(indexPath.row, at: tableArr.count-1)

                let subTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 300), style: .plain)

                subTableView.delegate = self
                subTableView.dataSource = self
                subTableView.rowHeight = 40
                subTableView.separatorStyle = .none
                subTableView.tableFooterView = UIView()
                subTableView.tag = tableArr.count
                self.screenGrayView.addSubview(subTableView)
                subTableView.customDataSourse = tableView.customDataSourse[indexPath.row].mySubList
                tableArr.append(subTableView)
                
            }
            for i in 0..<tableArr.count {
                tableArr[i].frame = CGRect(x:Int(self.frame.width)/tableArr.count * i, y: 0, width: Int(self.frame.width)/tableArr.count, height: 300)
            }
        }else{
            for i in 0..<tableArr.count {
                if tableArr[i] == tableView && indexPath.row == 0{
                    if i > 0{
                        //block 到页面刷新数据
                        block?(currentTable,tableArr[i-1].customDataSourse[chooseRow[i-1]],i-1)
                        titleBtnArr[currentTable].setTitle(tableArr[i-1].customDataSourse[chooseRow[i-1]].content, for: .normal)
                        titleBtnArr[currentTable].imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: CGFloat(-(tableArr[i - 1].customDataSourse[chooseRow[i-1]].content.count * 30)))
                        titleBtnArr[currentTable].titleEdgeInsets = .init(top: 0, left: -30, bottom: 0, right: 0)
                        titleBtnArr[currentTable].isSelected = false
                        mainTable.isHidden = true
                        screenGrayView.isHidden = true
                        for i in 1..<tableArr.count {
                            tableArr[i].removeFromSuperview()
                        }
                        tableArr.removeAll()
                        tableArr.append(mainTable)
                        return
                    }
                }
            }
            
            //block 到页面刷新数据
            block?(currentTable,tableView.customDataSourse[indexPath.row],0)
            titleBtnArr[currentTable].setTitle(tableView.customDataSourse[indexPath.row].content, for: .normal)
            titleBtnArr[currentTable].setTitleColor(.red, for: .normal)
            titleBtnArr[currentTable].imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: CGFloat(-(tableView.customDataSourse[indexPath.row].content.count * 30)))
            titleBtnArr[currentTable].titleEdgeInsets = .init(top: 0, left: -30, bottom: 0, right: 0)
            titleBtnArr[currentTable].isSelected = false
            mainTable.isHidden = true
            screenGrayView.isHidden = true
            for i in 1..<tableArr.count {
                tableArr[i].removeFromSuperview()
            }
            tableArr.removeAll()
            tableArr.append(mainTable)
        }
    }
    /// 灰色背景
    lazy var screenGrayView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickScreenGrayView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        gDelegate.window?.addSubview(view)
        view.frame = CGRect(x: 0, y: kNavBarHeight + 80, width: kScreenWidth, height: kScreenHeight)
        return view
    }()
    
    /// 点击灰色背景
    @objc func clickScreenGrayView(){
        self.screenGrayView.isHidden = true
        for subView in screenGrayView.subviews {
            subView.isHidden = true
        }
        currentBtn.isSelected = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ScreeningView: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.screenGrayView {
            return true
        }
        return false
    }
}

