//
//  ViewController.swift
//  CustomDataPicker
//
//  Created by Qian Zhou on 15/11/2.
//  Copyright © 2015年 Qian Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomDataPickerDelegate {

    
    
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var customPickerLabel: UILabel!
    @IBOutlet weak var nullablePickerLabel: UILabel!
    @IBOutlet weak var addressPickerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func tapDatePicker(sender: UITapGestureRecognizer) {
        let picker: CustomDataPicker = CustomDataPicker.init(defaultDate: NSDate())
        picker.delegate = self;
        self.view.addSubview(picker)
    }

    @IBAction func tapCustomPicker(sender: AnyObject) {
        let dataArray = ["AB", "A", "B", "O"]
        let picker: CustomDataPicker = CustomDataPicker.init(dataArray: dataArray, initalSelection: ["B"])
        picker.delegate = self;
        self.view.addSubview(picker)
    }
    
    @IBAction func tapNullablePicker(sender: UITapGestureRecognizer) {
        let picker: CustomDataPicker = CustomDataPicker.init(year: 2000, month: 1, day: 1)
        picker.delegate = self;
        self.view.addSubview(picker)
    }
    
    @IBAction func tapAddressPicker(sender: UITapGestureRecognizer) {
        let picker: CustomDataPicker = CustomDataPicker.init(addressArray: [])
        picker.delegate = self;
        self.view.addSubview(picker)
    }
    
    
    func customDataPicker(pickerView: CustomDataPicker, DoneClickResultsArray array: [NSString]) {
        if pickerView.type == CustomDataPickerType.datePicker {
            datePickerLabel.text = array[0] as String
        }
        if pickerView.type == CustomDataPickerType.customPicker {
            customPickerLabel.text = array[0] as String
        }
        if pickerView.type == CustomDataPickerType.nullablePicker {
            nullablePickerLabel.text = (array[0] as String) + (array[1] as String) + (array[2] as String)
        }
        if pickerView.type == CustomDataPickerType.addressPicker {
            addressPickerLabel.text = (array[0] as String) + (array[1] as String) + (array[2] as String)
        }
    }
}

