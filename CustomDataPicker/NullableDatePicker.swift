//
//  NullableDatePicker.swift
//  CustomDataPicker
//
//  Created by Qian Zhou on 15/11/6.
//  Copyright © 2015年 Qian Zhou. All rights reserved.
//

import UIKit



class NullableDatePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    var years = [Int]()
    var monthes = [Int]()
    var days = [Int]()
    let today: NSDateComponents
    let maxRow = 8192
    
    var picker: UIPickerView?
    
    convenience init() {
        self.init(year: 2000, month: 1, day: 1, yPosition: 300)
    }
    init(year: Int, month: Int, day: Int, yPosition: CGFloat) {
        today = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())

        let picker = UIPickerView()
        let oldFrame = picker.frame
        let newFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, oldFrame.size.height)
        let selfFrame = CGRectMake(0, yPosition, newFrame.size.width, newFrame.size.height)
        super.init(frame: selfFrame)
        
        self.frame = selfFrame
        picker.frame = newFrame
        picker.delegate = self
        picker.dataSource = self
        addSubview(picker)
        self.picker = picker
        
        for var i = 1900; i <= today.year; i++ {
            years.append(i)
        }
        for var i = 0; i <= 12; i++ {
            monthes.append(i)
        }
        for var i = 0; i <= 31; i++ {
            days.append(i)
        }
        
        picker.selectRow(years.indexOf(year)!, inComponent: 0, animated: false)
        picker.selectRow(monthes.indexOf(month)!+maxRow/2/13*13, inComponent: 1, animated: false)
        picker.selectRow(days.indexOf(day)!+maxRow/2/32*32, inComponent: 2, animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    *  pickerView dataSource
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else {
            return maxRow
        }
    }
    
    /**
    *  pickerView delegate
    */
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let selected = selectedDatas()
        
        switch component {
        case 0:
            return NSAttributedString(string: "\(years[row])年")
        case 1:
            let actualRow = row % 13
            if actualRow == 0 { return NSAttributedString(string: "不记得")}
            
            if selected.year == today.year && actualRow > today.month {
                //超出今天的日期范围，灰色字体显示
                return NSAttributedString(string: "\(monthes[actualRow])月", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
            } else {
                return NSAttributedString(string: "\(monthes[actualRow])月")
            }
        case 2:
            let actualRow = row % 32
            if actualRow == 0 {return NSAttributedString(string: "不记得")}
            if actualRow > dayComponent() || selected.month % 13 == 0 || (selected.year >= today.year && selected.month >= today.month && actualRow > today.day) {
                //超出今天的日期范围，灰色字体显示
                return NSAttributedString(string: "\(days[actualRow])日", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
            } else {
                return NSAttributedString(string: "\(days[actualRow])日")
            }
        default:
            return nil
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(2)
        let selected = selectedDatas()
        let selectedMonthRow = pickerView.selectedRowInComponent(1)
        let selectedDayRow = pickerView.selectedRowInComponent(2)
        
        if selected.year == today.year && selected.month > today.month ||
            selected.month == today.month && selected.day >= today.day {
                
            pickerView.selectRow(selectedMonthRow/13*13+today.month, inComponent: 1, animated: true)
                if selected.day > today.day {
                    pickerView.selectRow(selectedDayRow/32*32+today.day, inComponent: 2, animated: true)
                }
        } else if selectedMonthRow % 13 == 0 {
            pickerView.selectRow(selectedDayRow - selectedDayRow%32, inComponent: 2, animated: true)
        } else if selectedDayRow % 32 > dayComponent() {
            pickerView.selectRow(selectedDayRow/32*32+dayComponent(), inComponent: 2, animated: true)
        }
        
        
        
    }
    
    func selectedDatas() -> (year: Int, month: Int, day: Int) {
        return (years[picker!.selectedRowInComponent(0)], monthes[picker!.selectedRowInComponent(1)%13], days[picker!.selectedRowInComponent(2)%32])
    }
    func dayComponent() -> Int {
        let year = picker!.selectedRowInComponent(0)
        let month = picker!.selectedRowInComponent(1) % 13
        if month == 0 { return 0}
        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 {
            return 31
        }
        if month == 4 || month == 6 || month == 9 || month == 11 {
            return 30
        }
        if year % 4 == 0 {
            return 29
        }
        return 28
    }
    
    
    
}
