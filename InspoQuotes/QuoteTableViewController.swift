//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

// MARK: com.jacobmorrison.InspoQuotes.PremiumQuotes
// This is the product id used when setting up the in-app purchases for the premium quotes

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let productId = "com.jacobmorrison.InspoQuotes.PremiumQuotes"
    
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
        
        // When you add a new protocol - SKPaymentTransactionObserver - and you want to use it's delegate method you have to declare
        // a class as the delegate. We want to declare the current class - QuoteTableviewController - as the delegate who is going
        // to receive the messages from the SKPaymentTransactionObserver when the transaction status changes.
        SKPaymentQueue.default().add(self)

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return quotesToShow.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if (indexPath.row < quotesToShow.count){
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 // setting to 0 uses as many lines as neccessary, see documentation
        } else {
            cell.textLabel?.text = "Buy more quotes"
            // 160,210,224
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
        // need to make sure phone is enabled, no parental controls set
        if SKPaymentQueue.canMakePayments() {
            // can make payments
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            // can't make payments
            print("User can't make payments.")
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // It is possible to have multiple transations becuase multiple transactions can happen in the same queue
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // payment successfull
                print("payment successful")
            } else if transaction.transactionState == .failed {
                // payment failed or user cancelled payment
                print("payment failed")
            }
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
    }
}
