//
//  CustomDataPicker.swift
//  CustomDataPicker
//
//  Created by Qian Zhou on 15/11/2.
//  Copyright © 2015年 Qian Zhou. All rights reserved.
//

import UIKit


@objc protocol CustomDataPickerDelegate: class {
    optional func customDataPicker(pickerView: CustomDataPicker, DoneClickResultsArray array: [NSString])
    //implement it to hide the picker when used as text field or text view's input view
    optional func customDataPickerShouldDisappear()
    optional func customDataPicker(pickerView: CustomDataPicker, didSelectRow row: NSInteger, inComponent component: NSInteger)
}

enum CustomDataPickerType {
    case datePicker
    case customPicker
    case nullablePicker
    case addressPicker
}

class CustomDataPicker: UIView, CustomDataPickerDelegate, UIPickerViewDelegate {
    
    
    var resultsArray = [String]()
    
    
    weak var delegate: CustomDataPickerDelegate?
    
    //subViews
    var backgroundView: UIView!
    var datePicker: UIDatePicker?
    var customPicker: CustomPicker?
    var nullablePicker: NullableDatePicker?
    var addressPicker: AddressPicker?
    
    //variables
    var pickerViewHeight: CGFloat = 0.0
    
    var hasToolBar = true
    var isDecorationView = false
    
    var type: CustomDataPickerType
    
    //constant
    let toolbarHeight: CGFloat = 40.0
    let animateDuration: NSTimeInterval = 0.3
    let screenSize = UIScreen.mainScreen().bounds.size
    
    
    
    
    
    /**
     initialization
    */

    init(dataArray: [AnyObject], initalSelection:[String]?, isDecorationView: Bool, hasToolbar: Bool) {
        type = .customPicker

        self.hasToolBar = hasToolbar
        self.isDecorationView = isDecorationView
        
        
        
        super.init(frame: CGRectZero)
        
        setMainView(isDecorationView, hasToolbar: hasToolbar)
        self.customPicker = setupPickerView(dataArray, initArray: initalSelection, isDecorationView: isDecorationView, hasToolbar: hasToolbar)
        
        show(isDecorationView, hasToolbar: hasToolbar)
    }
    
    convenience init(dataArray: [AnyObject], initalSelection:[String]?) {
        self.init(dataArray: dataArray, initalSelection:initalSelection, isDecorationView: false, hasToolbar: true)
    }
    
    
    
    
    init(defaultDate: NSDate?, isDecorationView: Bool, hasToolbar: Bool, timeMode: Bool) {
        type = .datePicker
        self.hasToolBar = hasToolbar
        self.isDecorationView = isDecorationView
        
        super.init(frame: CGRectZero)
        
        setMainView(isDecorationView, hasToolbar: hasToolbar)
        self.datePicker = setupDatePicker(defaultDate, isDecorationView: isDecorationView, hasToolbar: hasToolbar, timeMode: timeMode)
        
        show(isDecorationView, hasToolbar: hasToolbar)
    }

    convenience init(defaultDate: NSDate?) {
        self.init(defaultDate: defaultDate, isDecorationView: false, hasToolbar: true, timeMode: false)
    }

    
    
    init(addressArray: [String], isDecorationView: Bool, hasToolbar: Bool) {
        type = .addressPicker
        self.hasToolBar = hasToolbar
        self.isDecorationView = isDecorationView
        
        super.init(frame: CGRectZero)
        
        setMainView(isDecorationView, hasToolbar: hasToolbar)
        self.addressPicker = setupAddressPicker(addressArray, isDecorationView: isDecorationView, hasToolbar: hasToolbar)
        
        show(isDecorationView, hasToolbar: hasToolbar)
    }
    
    convenience init(addressArray: [String]) {
        self.init(addressArray: addressArray, isDecorationView: false, hasToolbar: true)
    }
    
    
    
    init(year: Int, month: Int, day: Int, isDecorationView: Bool, hasToolbar: Bool) {
        type = .nullablePicker
        self.hasToolBar = hasToolbar
        self.isDecorationView = isDecorationView
        
        super.init(frame: CGRectZero)
        setMainView(isDecorationView, hasToolbar: hasToolbar)
        self.nullablePicker = setupNullableDatePicker(year, month: month, day: day, isDecorationView: isDecorationView, hasToolbar: hasToolbar)
        
        show(isDecorationView, hasToolbar: hasToolbar)
    }
    
    convenience init(year: Int, month: Int, day: Int) {
        self.init(year: year, month: month, day: day, isDecorationView: false, hasToolbar: true)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    func setMainView(isDecorationView: Bool, hasToolbar: Bool) {
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        backgroundView = UIView(frame: CGRectMake(0, screenSize.height, screenSize.width, 0))
        backgroundView.backgroundColor = UIColor.whiteColor()
        
        if hasToolbar == true {
            let toolbar = setupToolbar()
            if isDecorationView == true {
                addSubview(toolbar)
            } else {
                backgroundView.addSubview(toolbar)
            }
        }
    }
    
    func setupToolbar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, screenSize.width, toolbarHeight))
        let leftButton: UIBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "docancel")
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "doneClick")
        let centerSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolBar.items = [leftButton, centerSpace, rightButton]
        
        return toolBar
    }
    
    
    
    func setupPickerView(dataArray: [AnyObject], initArray: [String]?, isDecorationView: Bool, hasToolbar: Bool) -> CustomPicker {
        
        var y: CGFloat = 0
        if hasToolbar == true {
            y = toolbarHeight
        }
        
        let picker = CustomPicker(dataArray: dataArray, initalSelection: initArray, yPosition: y)
        pickerViewHeight = picker.frame.size.height
        
        if isDecorationView == true {
            addSubview(picker)
        } else {
            backgroundView.addSubview(picker)
            addSubview(backgroundView)
        }
        
        return picker
        
    }
    
    
    
    func setupDatePicker(originDate: NSDate?, isDecorationView: Bool, hasToolbar: Bool, timeMode: Bool) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.backgroundColor = UIColor.whiteColor()
        
        if timeMode == true {
            datePicker.datePickerMode = .Time
        } else {
            datePicker.datePickerMode = .Date
        }
        
        if let date = originDate {
            datePicker.setDate(date, animated: false)
        }
        
        if hasToolbar == true {
            datePicker.frame = CGRectMake(0, toolbarHeight, backgroundView.frame.size.width, datePicker.frame.size.height)
        } else {
            datePicker.frame = CGRectMake(0, 0, backgroundView.frame.size.width, datePicker.frame.size.height)
        }
        
        //set minimumDate as 1900-1-1
        let dateComponent = NSDateComponents()
        dateComponent.year = 1900
        dateComponent.month = 1
        dateComponent.day = 1
        let minimumDate = NSCalendar.currentCalendar().dateFromComponents(dateComponent)
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = NSDate()
        
        pickerViewHeight = datePicker.frame.size.height
        
        if isDecorationView == true {
            //用作textfield / textView的inputView
            addSubview(datePicker)
        } else {
            backgroundView.addSubview(datePicker)
            addSubview(backgroundView)
        }
        
        return datePicker

    }
    
    func setupAddressPicker(initArray: [String], isDecorationView: Bool, hasToolbar: Bool) -> AddressPicker {
        var y: CGFloat = 0
        if hasToolbar == true {
            y = toolbarHeight
        }
        let addressPicker = AddressPicker(initArray: initArray, yPosition: y)
        pickerViewHeight = addressPicker.frame.size.height
        
        if isDecorationView == true {
            addSubview(addressPicker)
        } else {
            backgroundView.addSubview(addressPicker)
            addSubview(backgroundView)
        }
        
        return addressPicker
    }
    
    func setupNullableDatePicker(year: Int, month: Int, day: Int, isDecorationView: Bool, hasToolbar: Bool) -> NullableDatePicker {
        var y: CGFloat = 0
        if hasToolbar == true {
            y = toolbarHeight
        }
        let nullablePicker = NullableDatePicker(year: year, month: month, day: day, yPosition: y)
        pickerViewHeight = nullablePicker.frame.size.height
        
        if isDecorationView == true {
            addSubview(nullablePicker)
        } else {
            backgroundView.addSubview(nullablePicker)
            addSubview(backgroundView)
        }
        
        return nullablePicker
    }
    
    
    func backgroundDismiss() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "bgtappedCancel")
        self.addGestureRecognizer(tap)
    }
    
    
    func show(isDecorationView: Bool, hasToolbar: Bool) {
        let vfHeight: CGFloat = hasToolbar ? pickerViewHeight + toolbarHeight : pickerViewHeight
        let vfOriginY: CGFloat = screenSize.height - vfHeight
        
        if isDecorationView == true {
            self.frame = CGRectMake(0, screenSize.height, screenSize.width, vfHeight)
        } else {
            self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
            self.backgroundView.frame = CGRectMake(0, screenSize.height, screenSize.width, screenSize.height)
        }
        
        if isDecorationView == true {
            UIView.animateWithDuration(animateDuration, animations: { [weak self] in
                self?.frame = CGRectMake(0, vfOriginY, (self?.screenSize.width)!, vfHeight)
                self?.alpha = 1
            })
        } else {
            UIView.animateWithDuration(animateDuration, animations: { [weak self] in
                self?.backgroundView.frame = CGRectMake(0, vfOriginY, (self?.screenSize.width)!, vfHeight)
                self?.alpha = 1
            })
        }
    }
    
    func dismissView() {
        if isDecorationView == true {
            self.delegate?.customDataPickerShouldDisappear?()
        } else {
            UIView.animateWithDuration(animateDuration, animations: { [weak self] in
                self?.frame = CGRectMake(0, (self?.screenSize.height)!, (self?.screenSize.width)!, 0)
                self?.alpha = 0
                }) { [weak self](let finished) -> Void in
                    if finished == true {
                        self?.removeFromSuperview()
                    }
            }
        }
        
    }
    
    func doneClick() {
        dismissView()
        switch type {
        case .datePicker:
            resultsArray.append(self.datePicker!.date.description)
        case .customPicker:
            resultsArray.appendContentsOf(self.customPicker!.selectedData())
        case .nullablePicker:
            let selected = self.nullablePicker!.selectedDatas()
            resultsArray.append("\(selected.year)")
            resultsArray.append("\(selected.month)")
            resultsArray.append("\(selected.day)")
        case .addressPicker:
            resultsArray.append(self.addressPicker!.resultProvice)
            resultsArray.append(self.addressPicker!.resultCity)
            resultsArray.append(self.addressPicker!.resultRegion)
        
        }
        self.delegate?.customDataPicker?(self, DoneClickResultsArray: resultsArray)
    }
    
    func docancel() {
        dismissView()
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if hasToolBar == false {
            self.delegate?.customDataPicker?(self, didSelectRow: row, inComponent: component)
        }
    }
    
    
    
    
}
