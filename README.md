# BabyCustomScreening
Swift自定义下拉筛选框，多组可以，多个table也可以
根据传入数据，可以任意组数，每一组下可以有多个table，即点击行，如继续有数据，便可显示，在创建view时给到数据即可
```        
let screeningView = ScreeningView(frame: CGRect(x: 0, y: 100, width: kScreenWidth, height: 40), sectionNum: 3)
```
数据是拼成的model，如果是网络请求的数据，直接解析该model即可，如果是自定义数据，需自己创建
```
let arr1 = ["2-1","2-2","2-3","2-4","2-5"]
let mo2 = SceeningModel()
  mo2.content = "第二组"
  for str in arr1 {
    let model = SceeningModel()
    model.content = str
    mo2.mySubList.append(model)
  }
```
点击每一行的回调，section是哪一组，model是所选行的数据，row为所选行
```
screeningView.block = {
  [weak self] section ,model, row in
}
```
