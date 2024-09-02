//
//  ViewController.swift
//  t3c-tac-toe
//
//  Created by mcman on 9/2/24.
//
import ConfettiSwiftUI
import UIKit
import SwiftUI

class ViewController: UIViewController {
    @ObservedObject var confettiModel = ConfettiModel()

    var cannonHost: UIHostingController<CannonView>?
    var cannonView: CannonView?
   
    
    enum Turn {
        case Nought
        case Cross
        
        var title: String {
            switch self {
            case Turn.Nought:
                return "O"
            case Turn.Cross:
                return "X"
            }
        }
        
    }
    
    static var firstTurn = [Turn.Nought,Turn.Cross][Int.random(in: 0...1)] // randomly pick a turn
    var currentTurn = firstTurn
    
    var board = [UIButton]()
    
    let winningMoves: [[Int]] = [[0,1,2],
                        [3,4,5],
                        [6,7,8],
                        [0,3,6],
                        [1,4,7],
                        [2,5,8],
                        [0,4,8],
                        [2,4,6]]
    
    @IBOutlet weak var turnLabel: UILabel!
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        
        cannonView = CannonView(confettiModel: confettiModel)
        cannonHost = UIHostingController(rootView: cannonView! )
               addChild(cannonHost!)
               view.addSubview(cannonHost!.view)
        cannonHost!.didMove(toParent: self)
//        cannonHost?.view.frame = view!.frame
//        cannonHost?.view.frame = .init(x: 50, y: 700, width: 200, height: 200)
            
        cannonHost!.view.translatesAutoresizingMaskIntoConstraints = false
        cannonHost!.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = false
        cannonHost!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cannonHost!.view.widthAnchor.constraint(equalToConstant: 200)
        cannonHost!.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cannonHost!.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    func initBoard(){
        board.append(a1)
        board.append(a2)
        board.append(a3)
       
        board.append(b1)
        board.append(b2)
        board.append(b3)

        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)
        
        
        if (fullBoard()){
            resultAlert(title: "draw")
        }
    }
    
    func resultAlert(title:String){
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
            
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard(){
        board.forEach { btn in
            btn.setTitle( nil, for: .normal)
            btn.isEnabled = true
        }
        
        currentTurn = [
                    Turn.Cross: Turn.Nought,
                    Turn.Nought: Turn.Cross
                ][ViewController.firstTurn] as! Turn
        
        ViewController.firstTurn = currentTurn
        
        turnLabel.text = currentTurn.title
    }
    
    func fullBoard() ->Bool {
        return board.allSatisfy { btn in
            return btn.title(for: .normal) != nil
        }
    }
    
    func winningMove() ->Bool{
        return winningMoves.contains { op in
            let firstValue = board[op[0]]
           let secondValue = board[op[1]]
           let thirdValue = board[op[2]]

            return (firstValue.title(for: .normal) == secondValue.title(for: .normal) && secondValue.title(for: .normal) == thirdValue.title(for: .normal)) && firstValue.title(for: .normal) != nil


        }
    }
    
    
    func addToBoard(_ sender: UIButton) {
        if (sender.title(for: .normal) == nil){
            sender.setTitle(currentTurn.title, for: .normal)
           
            if (winningMove()){
                confettiModel.increment()
                return self.resultAlert(title: "\(self.currentTurn.title) won")
            }
            
            currentTurn =  (currentTurn == Turn.Nought) ? Turn.Cross : Turn.Nought
            turnLabel.text = "\(currentTurn.title)"
        }
        sender.isEnabled = false
    }
    
}

