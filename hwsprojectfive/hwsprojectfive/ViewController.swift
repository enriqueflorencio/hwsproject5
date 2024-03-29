//
//  ViewController.swift
//  hwsprojectfive
//
//  Created by Enrique Florencio on 6/7/19.
//  Copyright © 2019 Enrique Florencio. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usersWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        //We need to unwrap the optional and see if start.txt exists
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            //We need to get the strings within the txt file
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        //if allWords.isEmpty is a LOT faster than (if allWords.count == 0)
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
        
    }
    
    //Begin the game
    func startGame() {
        title = allWords.randomElement()
        usersWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func isPossible(word: String) -> Bool {
        
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usersWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return mispelledRange.location == NSNotFound
    }
    
    func submit(_ answer: String) {
        /*We need to lower case every answer just in case the player tries to pull a fast one ex
         Cease and cease are different. We need to lower case each one so that the user doesn't get
         extra points */
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    //Insert this word into the very beginning of the array
                    usersWords.insert(answer, at: 0)
                    
                    //update the tableview to present the new word
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible!"
            errorMessage = "You can't spell that word from \(title)"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OIK", style: .default))
        present(ac, animated: true)
    }
    
    //Define number of rows per usual
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersWords.count
    }
    
    //define the cells per usual
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usersWords[indexPath.row]
        return cell
    }
    
    //objective-C function for the compiler to notice, this also gathers user input
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        //Trailing closures aren't bad at all. Note: Refer to page 256 in case I find myself stuck again with the syntax
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            //action can be replaced with _ since we aren't using action at all in the closure
            [weak self, weak ac] _ in
            
            //This line unwraps the array of text fields (the user's answer) hence, answer
            guard let answer = ac?.textFields?[0].text else {
                return
            }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
}

