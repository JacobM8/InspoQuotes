//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    //let productId = "com.jacobmorrison.InspoQuotes.PremiumQuotes"
    let productId = "Premium_Quotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPurchased(){
            showPremiumQuotes()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // When you add a new protocol - SKPaymentTransactionObserver - and you want to use it's delegate method you have to declare
        // a class as the delegate. We want to declare the current class - QuoteTableviewController - as the delegate who is going
        // to receive the messages from the SKPaymentTransactionObserver when the transaction status changes because it is implementing
        // the required functions for the protocol.
        SKPaymentQueue.default().add(self)
        
        return true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isPurchased() {
            return quotesToShow.count
        }
        
        return quotesToShow.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if (indexPath.row < quotesToShow.count){
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 // setting to 0 uses as many lines as neccessary, see documentation
            cell.textLabel?.textColor = .white
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Buy more quotes"
            cell.textLabel?.textColor = UIColor(#colorLiteral(red: 0.193, green: 0.51, blue: 0.75, alpha: 255))
            cell.accessoryType = .disclosureIndicator
        }
        
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - In-app purchase methods
    
    func buyPremiumQuotes() {
        // Check to make sure phone is enabled, no parental controls set
        if SKPaymentQueue.canMakePayments() {
            // Can make payments
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
            //print("User can make payments")
        } else {
            // Can't make payments
            print("User can't make payments.")
        }
        
    }
    
    // Whenever any changes happen to the payment transactions the app will contact the QuoteTableViewController
    // and find this delegate method to trigger and update.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // It is possible to have multiple transations becuase multiple transactions can happen in the same queue
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // Payment successfull
                print("Transaction successful")
                showPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                // Payment failed or user cancelled payment
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Payment failed due to error: \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                showPremiumQuotes()
                print("transaction restored")
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes(){
        
        UserDefaults.standard.set(true, forKey: productId)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productId)
        
        if purchaseStatus {
            print("previously purchased")
            
            return true
        } else {
            print("never purchased")
            
            return false
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        print("in restored func")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
