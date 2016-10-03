//
//  ViewController.swift
//  TextFileCSVDemo
//
//  Created by Alex Koumparos on 02/10/16.
//  Copyright © 2016 Koumparos Software. All rights reserved.
//

import UIKit

enum FileResult {
    case success
    case failure(String)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - VC Functions
    // --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - @IBActions
    // ------------------
    
    @IBAction func resetTapped(_ sender: UIButton) {
        textView.text = "Nope, no pizza here."
    }
    
    @IBAction func loadTapped(_ sender: UIButton) {
        textView.text = readDataFromFile(file: "data")
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        let result = writeDataToFile(file: "data")
        switch result {
        case .success:
            print("data written")
        case .failure(let str):
            print("saveTapped received error: \(str)")
        }
    }
    
    @IBAction func reportTapped(_ sender: UIButton) {
    }

    
    // MARK: - App-specific functions
    // ------------------------------
    
    func readDataFromFile(file: String, type: String = "txt") -> String? {
        guard let filePath = Bundle.main.path(forResource: file, ofType: type) else {
            print("ERROR: Unable to find file \(file).\(type)")
            return nil
        }
        
        do {
            let contents = try String(contentsOfFile: filePath)
            return contents
        } catch {
            print("ERROR: Unable to read contents of file \(filePath)")
            return nil
        }
    }
    
    //FIXME: This function works on the simulator but not a a real device.
    func writeDataToFile(file: String, type: String = "txt") -> FileResult {
        
        //check the data exist
        guard let data = textView.text else { return .failure("ERROR: no text to write") }
        
        // get the file path for the file in the bundle
        // if the file doesn't exist, create it
        var fileName = "\(file).\(type)"
        
        if let filePath = Bundle.main.path(forResource: file, ofType: type) {
            fileName = filePath
        } else {
            fileName = Bundle.main.bundlePath + fileName
        }
        
        // write the file, returning .success if successful, .failure() otherwise
        do {
            try data.write(toFile: fileName, atomically: true, encoding: String.Encoding.unicode) // note: atomically means that the whole file will be written to a temp file before that tempfile is copied to the destination filename (ensures that destination filename is not corrupted if the initial write to disk is interrupted).
            return .success
        } catch {
            return .failure("ERROR: Unable to write to \(fileName)")
        }
    }
    

}

