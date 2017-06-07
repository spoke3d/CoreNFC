//
//  ViewController.swift
//  CodeNFC
//
//  Created by Dmitry Danilov on 06/06/2017.
//  Copyright © 2017 DDanilov. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    var textView: UITextView?
    var nfcReaderSession: NFCNDEFReaderSession?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView = UITextView.init(frame: self.view.bounds)
        textView?.font = UIFont.systemFont(ofSize: 16)
        textView?.text = "\nApp started\n"
        self.view.addSubview(textView!)
        
        nfcReaderSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        nfcReaderSession?.begin()
        
        appendDisplayText("NFC Reader ready \(nfcReaderSession!.isReady)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Add text
    
    func appendDisplayText(_ text: String?) {
        if let appendText = text {
            DispatchQueue.main.async {
                var currentText = self.textView?.text
                currentText?.append("\(appendText)\n")
                self.textView?.text = currentText
            }
        }
    }
    
    //MARK: NFC Reader Session Delegate
    
//    func readerSessionDidBecomeActive(_ session: NFCReaderSession) {
//        appendDisplayText("Session started: \(session.description)")
//    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        appendDisplayText("Session received error \(error.localizedDescription)")
    }
    
//    open var typeNameFormat: NFCTypeNameFormat
//    
//    open var type: Data
//    
//    open var identifier: Data
//    
//    open var payload: Data
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var resultText = ""
        for message in messages {
            var record = "Message: \n"
            for payload in message.records {
                let original = "typeName \(payload.typeNameFormat) type \(payload.type) identifier \(payload.identifier) \(payload.payload)"
                
                var tryToString = "typeName \(payload.typeNameFormat) "
                if let type = String.init(data: payload.type, encoding: .utf8) {
                    tryToString.append("type: \(type)")
                }
                if let identifier = String.init(data: payload.identifier, encoding: .utf8) {
                    tryToString.append("identifier: \(identifier)")
                }
                if let payload = String.init(data: payload.payload, encoding: .utf8) {
                    tryToString.append("payload: \(payload)")
                }
                
                
                record.append("origin: \(original)\n tryConvert: \(tryToString)\n\n")
            }
            resultText.append(record)
        }
        appendDisplayText(resultText)
    }
    
    
    //MARK:
    
    
    


}

