//
//  DatePickerView.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit

class DateFilterView: DiagView {
    let fromView = DatePickerView()
    let toView = DatePickerView()
    weak var delegate: DatePickerDelegate?
    
    func configCell(from: Date?, to: Date?) {
        fromView.configView(from)
        toView.configView(to)
    }
    
    override func setupView() {
        super.setupView()
        addSubviews(views: fromView, toView)
        fromView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().inset(padding)
            maker.bottom.top.equalToSuperview().inset(16)
            maker.trailing.equalTo(self.snp.centerX).offset(-8)
        }
        toView.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().inset(padding)
            maker.centerY.equalTo(fromView.snp.centerY)
            maker.leading.equalTo(self.snp.centerX).offset(8)
        }
        toView.titleLbl.text = "To"
        fromView.titleLbl.text = "From"
        fromView.pickDateAction = { [weak self] date in
            self?.delegate?.pickFromDate(date)
        }
        
        toView.pickDateAction = { [weak self] date in
            self?.delegate?.pickToDate(date)
        }
    }
}

class DatePickerView: DiagView {
    let titleLbl = UIMaker.makeTitleLabel()
    let dateLbl = UIMaker.makeContentLabel()
    let actionBtn = UIButton()
    var date: Date?
    var pickDateAction: ((Date) -> ())?
    
    func configView(_ date: Date?) {
        dateLbl.text = date?.dateFormat
        self.date = date
    }
    
    override func setupView() {
        super.setupView()
        let view = UIView()
        view.createBorder(1, color: UIColor.Diag.title_font)
        view.createRoundCorner(4)
        addSubview(titleLbl)
        addSubview(view)
        titleLbl.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
        }
        view.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(titleLbl.snp.bottom).inset(-2)
        }
        
        let icon = UIImageView(image: UIImage(named: "ic_history_calendar"))
        icon.contentMode = .scaleAspectFit
        view.addSubview(dateLbl)
        view.addSubview(icon)
        view.addSubview(actionBtn)
        icon.snp.makeConstraints { (maker) in
            maker.top.trailing.bottom.equalToSuperview().inset(12)
            maker.width.height.equalTo(16)
        }
        dateLbl.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.equalToSuperview().inset(8)
        }
        actionBtn.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        actionBtn.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    @objc func showDatePicker() {
        let popup = DatePopup()
        popup.show(in: UIApplication.shared.keyWindow ?? UIView(), date: date)
        popup.okAction = { [weak self] date in
            self?.pickDateAction?(date)
            DispatchQueue.main.async {
                self?.configView(date)
                self?.layoutIfNeeded()
            }
        }
    }
}

class DatePopup: DiagView {
    private let blackView = UIButton()
    private let titleLabel = UIMaker.makeTitleLabel(text: "Select Custom Date", color: .black, alignment: .center)
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    lazy var okBtn: UIButton = {
        let btn = UIButton()
        btn.createRoundCorner(4)
        btn.backgroundColor = UIColor.Diag.blue
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("OK", for: .normal)
        return btn
    }()
    var okAction: ((Date) -> ())?
    
    private func setup() -> UIView {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        blackView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        okBtn.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.color(hex: "D6D9E4")
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview().inset(padding)
            maker.leading.trailing.equalToSuperview()
        }
        
        let view = UIView()
        view.backgroundColor = .white
        view.createRoundCorner(7)
        view.addSubview(headerView)
        view.addSubview(datePicker)
        view.addSubview(okBtn)
        
        headerView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
        }
        datePicker.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(headerView.snp.bottom)
        }
        okBtn.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview().inset(padding)
            maker.top.equalTo(datePicker.snp.bottom)
            maker.height.equalTo(50)
        }
        return view
    }
    
    func show(in view: UIView, date: Date?) {
        if let tmp = date {
           datePicker.date = tmp
        }
        let container = setup()
        addSubview(blackView)
        addSubview(container)
        blackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        container.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(padding*1.5)
        }
        
        blackView.alpha = 0
        UIView.animate(withDuration: 0.1, animations:
            { [weak self] in self?.blackView.alpha = 1 })
        container.zoomIn(true)
        
        view.addSubview(self)
        self.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    @objc func dismiss() {
        removeFromSuperview()
    }
    
    @objc func didTapAction(button: UIButton) {
        removeFromSuperview()
        okAction?(datePicker.date)
    }
}

protocol DatePickerDelegate: NSObjectProtocol {
    func pickFromDate(_ date: Date)
    func pickToDate(_ date: Date)
}
