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
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {
                return
            }
            self?.submit(answer)
            ac?.addAction(submitAction)
            present(ac, animated: true)
        }
        
    }
    
}

