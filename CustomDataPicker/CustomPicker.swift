//
//  CustomPicker.swift
//  CustomDataPicker
//
//  Created by Qian Zhou on 15/11/6.
//  Copyright © 2015年 Qian Zhou. All rights reserved.
//

import UIKit

class CustomPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var isLevelArray = false
    var dataArray: [AnyObject]  //could an array or 2D array
    var results = [String]()

    var picker: UIPickerView?
    
    //中间变量
    var components = [Int]()
    var initSelectionArray:[String] = [String]()
    
    init(dataArray: [AnyObject], initalSelection:[String]?, yPosition: CGFloat) {
        if let _ = dataArray.first as? [String] {
            isLevelArray = true
        } else {
            isLevelArray = false
        }
        self.dataArray = dataArray
        
        
        let picker = UIPickerView()
        let oldFrame = picker.frame
        let newFame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, oldFrame.size.height)
        let selfFrame = CGRectMake(0, yPosition, newFame.size.width, newFame.size.height)
        super.init(frame: selfFrame)
        
        picker.frame = newFame
        picker.backgroundColor = UIColor.whiteColor()
        picker.delegate = self
        picker.dataSource = self
        addSubview(picker)
        self.picker = picker
        
        //set init selection
        if let originArray = initalSelection {
            initSelectionArray = originArray
            if let _ = originArray.first {
                
                if let _ = dataArray.first as? [String]! {
                    //数据是二维数组，dataPicker有多个component
                    for var i = 0; i < originArray.count; i++ {
                        for var j = 0; j < dataArray[i].count; j++ {
                            if (originArray[i]) == (dataArray[i][j] as! String) {
                                picker.selectRow(j, inComponent: i, animated: false)
                            }
                        }
                    }
                } else {
                    //数据源是一位数组，dataPicker只有一个component
                    for var i = 0; i < dataArray.count; i++ {
                        if (originArray[0]) == (dataArray[i] as! String) {
                            picker.selectRow(i, inComponent: 0, animated: false)
                        }
                    }
                }
                
                
            }
        } else {
            //initalSelection == nil, 默认选第一行
            if isLevelArray == true {
                for var i = 0; i < dataArray.count; i++ {
                    picker.selectRow(0, inComponent: i, animated: false)
                    initSelectionArray.append(dataArray[i][0] as! String)
                }
            } else {
                initSelectionArray.append(dataArray[0] as! String)
                picker.selectRow(0, inComponent: 0, animated: false)
            }
            
            
        }
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /**
     *  UIPickerView datasource
     */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if isLevelArray == true {
            return dataArray.count
        }
        
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isLevelArray == true {
            return dataArray[component].count
        }
        
        return dataArray.count
    }
    
    
    /**
     *  UIPickerView delegate
     */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isLevelArray == true {
            return dataArray[component][row] as? String
        }
        
        return dataArray[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        results.removeAll()
        if isLevelArray == true {
            //多个component, 将当前选择的component记下
            if components.contains(component) == false {
                components.append(component)
            }
            for var i = 0; i < dataArray.count; i++ {
                if components.contains(i) {
                    //选过的component
                    let selected = pickerView.selectedRowInComponent(i)
                    results.append(dataArray[i][selected] as! String)
                } else {
                    //没有选过的component默认initSelection
                    results.append(initSelectionArray[i])
                }
            }
        } else {
            //单个component
            results.append(dataArray[row] as! String)
        }
    }
    
    func selectedData() -> [String] {
        if isLevelArray == true {
            results.removeAll()
            for var i=0; i < dataArray.count; i++ {
                results.append(dataArray[i][(picker?.selectedRowInComponent(i))!] as! String)
            }
            return results
        } else {
            return [dataArray[(picker!.selectedRowInComponent(0))] as! String]
        }
        
    }

}
