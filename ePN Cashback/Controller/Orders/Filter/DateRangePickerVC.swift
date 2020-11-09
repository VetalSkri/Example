//
//  DateRangePickerVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 17/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import FSCalendar

class DateRangePickerVC: UIViewController {
    
    @IBOutlet weak var calendarPickerView: FSCalendar!
    @IBOutlet weak var acceptButton: UIButton!
    
    var viewModel: DateRangePickerViewModel!
    
    private let endDateRange = Date()
    private let startDateRange = Calendar.current.date(byAdding: .day, value: -180, to: Date())!
    private let df = DateFormatter()
    private var endDateRangeString = ""
    private var startDateRangeString = ""
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupView()
    }
     
    func setUpNavigationBar() {
        title = viewModel.headTitle()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney, NSAttributedString.Key.font : UIFont.semibold17]
        let rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Reset", comment: ""), style: .plain, target: self, action: #selector(resetButtonTapped))
        rightBarButtonItem.tintColor = .minsk
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupView() {
        self.view.backgroundColor = .zurich
        
        calendarPickerView.appearance.headerDateFormat = "MMMM, yyyy"
        calendarPickerView.allowsMultipleSelection = true
        calendarPickerView.delegate = self
        calendarPickerView.dataSource = self
        calendarPickerView.firstWeekday = (Util.languageOfContent() == "ru") ? 2 : 1
        calendarPickerView.calendarHeaderView.collectionView.internalDelegate = self
        if let range = viewModel.getInitDateRange() {
            df.dateFormat = "yyyy-MM-dd"
            let start = df.date(from: range.0)!
            let end = df.date(from: range.1)!
            let range = (start.timeIntervalSince(end) < 0) ? datesRange(from: start, to: end) : datesRange(from: end, to: start)
            if range.count > 1 {
                self.lastDate = range.last
            }
            self.firstDate = start
            for d in range {
                calendarPickerView.select(d)
            }
            datesRange = range
            calendarPickerView.select(firstDate, scrollToDate: true)
        }
        
        acceptButton.cornerRadius = CommonStyle.buttonCornerRadius
        acceptButton.backgroundColor = .moscow
        acceptButton.setTitleColor(.zurich, for: .normal)
        acceptButton.titleLabel?.font = .semibold15
        acceptButton.setTitle(NSLocalizedString("Apply", comment: ""), for: .normal)
    }
    
    @objc func resetButtonTapped() {
        for d in calendarPickerView.selectedDates {
            calendarPickerView.deselect(d)
        }
        
        lastDate = nil
        firstDate = nil
        
        datesRange = []
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    func changeMonthName(){
        print("MYLOG: changeMonthName() CALL")
        if Util.languageOfContent() != "ru" { return }
        let collectionView = calendarPickerView.calendarHeaderView.value(forKey: "collectionView") as! UICollectionView
        
        let monthNames = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        collectionView.visibleCells.forEach { (cell) in
            print("MYLOG: changeMonthName() reload cell!!!")
            if let c = cell as? FSCalendarHeaderCell, let dateString = c.titleLabel.text, let cellDate = dateFormatter.date(from: dateString) {
                let monthNumber = Calendar.current.component(.month, from: cellDate) - 1
                if monthNames.count > monthNumber {
                    c.titleLabel.text = "\(monthNames[monthNumber]), \(yearFormatter.string(from: cellDate))";
                }
            }
        }
    }
    
    @IBAction func acceptButtonClicked(_ sender: Any) {
        viewModel.apply(selectedDates: datesRange ?? [])
    }
    
}

extension DateRangePickerVC: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            
            print("MYLOG: DID SELECT select first date")
            
            return true
        }
        
        // only first date is selected
        if firstDate != nil && lastDate == nil {
            let range = (firstDate!.timeIntervalSince(date) < 0) ? datesRange(from: firstDate!, to: date) : datesRange(from: date, to: firstDate!)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            
            print("MYLOG: DID SELECT select range")
            
            return true
        }
        
        // both are selected
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
            print("MYLOG: DID SELECT Unselected range")
            return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            print("MYLOG: DID DESELECT deselect range")
        }
        if let firstDate = firstDate, lastDate == nil {
            let firtsDateString = df.string(from: firstDate)
            let selectedDateString = df.string(from: date)
            if firtsDateString == selectedDateString {
                datesRange = []
            }
            self.firstDate = nil
            print("MYLOG: DID DESELECT deselect fist date")
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("MYLOG: changeMonthName() FROM CALENDAR CURRENT PAGE DID CHANGE")
        changeMonthName()
    }
}

extension DateRangePickerVC: FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .day, value:-180, to: Date()) ?? Date(timeInterval: -(86400*180), since: Date())
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}

extension DateRangePickerVC: FSCalendarCollectionViewInternalDelegate {
    
    
    func collectionViewDidFinishLayoutSubviews(_ collectionView: FSCalendarCollectionView!) {
        changeMonthName()
        print("MYLOG: call from new delegate")
    }
    
}
