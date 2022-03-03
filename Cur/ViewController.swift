//
//  ViewController.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Cocoa

let currencyes: [CurrencyType] = [.RUB, .USD, .EUR, .JPY, .CNY, .INR, .HKD, .GEL, .IDR, .CZK, .AUD, .TRY]

class ViewController: NSViewController {

    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var bestWayButton: NSButton!
    @IBOutlet weak var timerButton: NSButton!

    let calculator = BestWayCalculator(currencyes: currencyes)
    let timer = RepeatingTimer(timeInterval: 1)
    var timerStep: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        startCalculator()

        timer.eventHandler = { [weak self] in
            self?.timerUpdate()
        }
    }

    @IBAction func actionTimer(_ sender: Any) {
        guard timer.state == .suspended else {
            timer.suspend()
            timerButton.title = "Timer"
            return
        }
        timerStep = 10
        timerButton.title = "Timer (\(timerStep))"
        timer.resume()
    }

    @IBAction func bestWay(_ sender: Any) {
        show { [weak self] in
            var transactions: [Transaction] = []
            for cur in currencyes {
                self?.calculator.optimize(startAmount: 1000, from: cur, to: cur).first.flatMap {
                    transactions.append($0)
                }
            }
            return transactions
        }
    }

    @IBAction func actionRubToUsd(_ sender: Any) {
        show(transactions: { [weak self] in
            Array(self?.calculator.optimize(startAmount: 1000, from: .RUB, to: .USD).prefix(15) ?? [])
        })
    }

    @IBAction func actionUsdToUsd(_ sender: Any) {
        show(transactions: { [weak self] in
            Array(self?.calculator.optimize(startAmount: 1000, from: .USD, to: .USD).prefix(15) ?? [])
        })
    }

    @IBAction func actionEurToEur(_ sender: Any) {
        show(transactions: { [weak self] in
            Array(self?.calculator.optimize(startAmount: 1000, from: .EUR, to: .EUR).prefix(15) ?? [])
        })
    }
    
    @IBAction func requestTap(_ sender: Any) {
        refreshCalculator()
    }
    
    @IBAction func loginTap(_ sender: Any) {
        login()
    }

}

extension ViewController {

    private func loginWithRequest(completion: @escaping () -> Void) {
        LoginScene.requestLogin(presenter: self, sessionParam: Session.live) { [weak self] in
            completion()
        }
    }

    private func login() {
        LoginScene.login(presenter: self, sessionParam: Session.live) { }
    }
}

extension ViewController {

    private func timerUpdate() {
        timerStep -= 1
        guard timerStep < 0 else {
            timerButton.title = "Timer (\(timerStep))"
            return
        }
        timerStep = 10
        timerButton.title = "Timer (\(timerStep))"

        activityIndicator.startAnimation(nil)
        activityIndicator.isHidden = false
        textView.isHidden = true

        calculator.refresh(completion: { [weak self] err in
            self?.activityIndicator.stopAnimation(nil)
            self?.activityIndicator.isHidden = true
            self?.textView.isHidden = false

            if let error = err {
                if error.isAuthError {
                    self?.loginWithRequest { [weak self] in
                        self?.refreshCalculator()
                    }
                } else {
                    print("Request failed with error: \(error)")
                }
            } else {
                self?.bestWay(1)
            }
        })
    }

    private func refreshCalculator() {
        activityIndicator.startAnimation(nil)
        activityIndicator.isHidden = false
        textView.isHidden = true

        calculator.refresh(completion: { [weak self] err in
            self?.activityIndicator.stopAnimation(nil)
            self?.activityIndicator.isHidden = true
            self?.textView.isHidden = false

            if let error = err {
                if error.isAuthError {
                    self?.loginWithRequest { [weak self] in
                        self?.refreshCalculator()
                    }
                } else {
                    print("Request failed with error: \(error)")
                }
            }
        })
    }

    private func startCalculator() {
        activityIndicator.startAnimation(nil)
        activityIndicator.isHidden = false
        textView.isHidden = true

        calculator.start(completion: { [weak self] err in
            self?.activityIndicator.stopAnimation(nil)
            self?.activityIndicator.isHidden = true
            self?.textView.isHidden = false
            if let error = err {
                if error.isAuthError {
                    self?.loginWithRequest { [weak self] in
                        self?.refreshCalculator()
                    }
                } else {
                    print("Request failed with error: \(error)")
                }
            }
        })
    }

    private func show(transactions: @escaping () -> [Transaction] ) {
        textView.string = " "
        DispatchQueue.main.async {
            let transactions = transactions()
            self.setAccent(accent: transactions.contains(where: { $0.hasProfit }))
            self.textView.string = transactions.sorted(by: { $0.toCount > $1.toCount }) .map { $0.description }.joined(separator: "\n")
            self.textView.font = NSFont.labelFont(ofSize: 18)
        }
    }

    private func setAccent(accent: Bool) {
        textView.backgroundColor = accent ? .red : .textBackgroundColor
    }
}
