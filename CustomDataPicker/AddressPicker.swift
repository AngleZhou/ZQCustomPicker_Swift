//
//  AddressPicker.swift
//  CustomDataPicker
//
//  Created by Qian Zhou on 15/11/5.
//  Copyright © 2015年 Qian Zhou. All rights reserved.
//

import UIKit

class AddressPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    var resultProvice: String = ""
    var resultCity: String = ""
    var resultRegion: String = ""
    
    //data
    var addresses = [AnyObject]()
    var provinces = [String]()
    var cities = [String]()
    var regions = [String]()
    
    //variables
    var selectedProvinceIndex: Int = 0
    var selectedCityIndex: Int = 0
    var selectedRegionIndex: Int = 0
    
    var selectedProvince: String = ""
    var selectedCity: String = ""
    var selectedRegion: String = ""

    
    init(initArray: [String], yPosition: CGFloat) {
        let pickerView = UIPickerView()
        
        let oldFrame = pickerView.frame
        pickerView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, UIScreen.mainScreen().bounds.size.width, oldFrame.size.height);
        let frame = CGRectMake(0, yPosition, pickerView.frame.size.width, pickerView.frame.size.height)
        
        super.init(frame: frame)
        self.frame = frame
        
        
        let path = NSBundle.mainBundle().pathForResource("address", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        addresses = (dic as! Dictionary)["address"]!
        for var i=0; i < addresses.count; i++ {
            let tempDic = addresses[i] as! [String:AnyObject]
            provinces.append(tempDic["name"] as! String)
        }
        
        if initArray.count == 0 {
            //默认第一个省的城市
            selectedProvinceIndex = 0;
            citiesOfProvinceIndex(selectedProvinceIndex)
            //默认第一个省的第一个城市的区
            selectedCityIndex = 0;
            selectedRegionIndex = 0;
            regionsOfCity(0, provinceIndex: 0)
        } else {
            selectedProvinceIndex = provinces.indexOf(initArray[0])!
            citiesOfProvinceIndex(selectedProvinceIndex)
            selectedCityIndex = cities.indexOf(initArray[1])!
            regionsOfCity(selectedCityIndex, provinceIndex: selectedProvinceIndex)
            selectedRegionIndex = regions.indexOf(initArray[2])!
        }
        resultProvice = provinces[selectedProvinceIndex]
        resultCity = cities[selectedCityIndex]
        resultRegion = regions[selectedRegionIndex]
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        addSubview(pickerView)
        if initArray.count > 0 {
            pickerView.selectRow(selectedProvinceIndex, inComponent: 0, animated: false)
            pickerView.selectRow(selectedCityIndex, inComponent: 1, animated: false)
            pickerView.selectRow(selectedRegionIndex, inComponent: 2, animated: false)
        }
   
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func citiesOfProvinceIndex(row: Int) {
        cities.removeAll()
        let subCities = (addresses[row] as! [String:AnyObject])["sub"]
        for var i=0; i < subCities!.count; i++ {
            let dic = subCities![i] as! [String:AnyObject]
            cities.append(dic["name"] as! String)
        }
    }
    
    func regionsOfCity(cityIndex: Int, provinceIndex: Int) {
        regions.removeAll()
        let cities = (addresses[provinceIndex] as! [String:AnyObject])["sub"]
        let array = (cities![cityIndex] as! [String:AnyObject])["sub"]
        regions.appendContentsOf(array as! [String])
    }
    

    
    /**
    *  pickerView Data Source
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinces.count
        case 1:
            return cities.count
        case 2:
            return regions.count
        default:
            return 0
        }
    }
    
    /**
    *  pickerView delegate
    */
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var tView = view as? UILabel
        if tView == nil {
            tView = UILabel()
            tView?.textAlignment = .Center
        }
        var title = ""
        switch component {
        case 0:
            title = provinces[row]
        case 1:
            title = cities[row]
        case 2:
            if regions.count == 0 { return tView!}
            title = regions[row]
        default:
            break
        }
        let componentWidth = pickerView.rowSizeForComponent(component).width
        var fontSize = 14
        var size: CGSize
        repeat {
            size = (title as NSString).sizeWithAttributes([NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(fontSize))])
            --fontSize
        } while size.width > componentWidth
        tView?.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        tView?.text = title
        
        return tView!
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            citiesOfProvinceIndex(row)
            regionsOfCity(0, provinceIndex: row)
            selectedProvinceIndex = row
            selectedCityIndex = 0
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            selectedRegionIndex = 0
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 1:
            regionsOfCity(row, provinceIndex: selectedProvinceIndex)
            selectedCityIndex = row
            selectedRegionIndex = 0
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
        case 2:
            selectedRegionIndex = row
        default:
            break
        }
        
        resultProvice = provinces[selectedProvinceIndex]
        resultCity = cities[selectedCityIndex]
        if regions.count == 0 {
            resultRegion = ""
        } else {
            resultRegion = regions[selectedRegionIndex]
        }
    }
}
