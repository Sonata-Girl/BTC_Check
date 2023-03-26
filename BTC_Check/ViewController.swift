//
//  ViewController.swift
//  BTC_Check
//
//  Created by Sonata Girl on 22.03.2023.
//

import UIKit

final class ViewController: UIViewController {
    private var manager = Manager()
    
    private var listRate = ["USD","BTC","EUR"]
    
    private var fromRateString = ""
    private var toRateString = ""

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rate of exchange"
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textColor = .label
        label.contentMode = .left
        label.textAlignment = .center
        return label
    }()
    
    private lazy var rateFromPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    private lazy var rateToPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    private lazy var getButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
//        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.setTitle("Get rate", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 20
        button.addTarget(nil, action: #selector(getButtonPressed), for: .touchUpInside)

        return button
    }()
    
    private lazy var titleRate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textColor = .label
        label.contentMode = .left
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        manager.delegate = self
        
        setupUI()
    }

    private func setupUI() {
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(rateFromPicker)
        NSLayoutConstraint.activate([
            rateFromPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 20),
            rateFromPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rateFromPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(rateToPicker)
        NSLayoutConstraint.activate([
            rateToPicker.topAnchor.constraint(equalTo: rateFromPicker.bottomAnchor,constant: 20),
            rateToPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rateToPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(getButton)
        NSLayoutConstraint.activate([
            getButton.topAnchor.constraint(equalTo: rateToPicker.bottomAnchor,constant: 20),
            getButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            getButton.heightAnchor.constraint(equalToConstant: 50),
            getButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        view.addSubview(titleRate)
        NSLayoutConstraint.activate([
            titleRate.topAnchor.constraint(equalTo: getButton.bottomAnchor,constant: 20),
            titleRate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleRate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc
    private func getButtonPressed() {
        let component = 0
        let fromRate = rateFromPicker.selectedRow(inComponent: component)
        let toRate = rateToPicker.selectedRow(inComponent: component)
        let fromString = rateFromPicker.delegate?.pickerView?(rateFromPicker, titleForRow: fromRate, forComponent: component) ?? ""
        let toString = rateToPicker.delegate?.pickerView?(rateToPicker, titleForRow: toRate, forComponent: component) ?? ""
        if !fromString.isEmpty , !toString.isEmpty {
            manager.getRate(fromCurrency: fromString, toCurrency: toString)
        }
    }

}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let result = "\(listRate[row])"
        return result
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listRate.count
    }
}

extension ViewController: ManagerDelegate {
    func didUpdateRate(_ managerDelegate: Manager, rate: String) {
        DispatchQueue.main.async {
            self.titleRate.text = rate
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
