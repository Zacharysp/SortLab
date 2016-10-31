//
//  ViewController.swift
//  SortLab
//
//  Created by Zachary on 10/30/16.
//  Copyright © 2016 Zachary. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var segmentContorl: UISegmentedControl!
    var startButton: UIButton!
    var resetButton: UIButton!
    var drawingView: UIView!
    var segmentItems = ["Insert", "Quick"]
    
    var numberArray: [CGFloat] = []
    var layerArray: [CAShapeLayer] = []
    
    var barWidth: CGFloat = 0
    var barHeightIndex: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElement()
        
    }
    
    func initUIElement(){
        startButton = UIButton(type: .custom)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.layer.cornerRadius = 5
        startButton.layer.borderColor = UIColor.blue.cgColor
        startButton.layer.borderWidth = 1
        startButton.setTitleColor(UIColor.blue, for: .normal)
        startButton.setTitle("Sort", for: .normal)
        startButton.addTarget(self, action: #selector(ViewController.sort), for: .touchUpInside)
        
        resetButton = UIButton(type: .custom)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.layer.cornerRadius = 5
        resetButton.layer.borderColor = UIColor.blue.cgColor
        resetButton.layer.borderWidth = 1
        resetButton.setTitleColor(UIColor.blue, for: .normal)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(ViewController.reset), for: .touchUpInside)
        
        segmentContorl = UISegmentedControl(items: segmentItems)
        segmentContorl.translatesAutoresizingMaskIntoConstraints = false
        segmentContorl.selectedSegmentIndex = 0
        
        drawingView = UIView(frame: .zero)
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(startButton)
        view.addSubview(resetButton)
        view.addSubview(segmentContorl)
        view.addSubview(drawingView)
        
        startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        resetButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        segmentContorl.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10).isActive = true
        segmentContorl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        segmentContorl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        drawingView.topAnchor.constraint(equalTo: segmentContorl.bottomAnchor, constant: 10).isActive = true
        drawingView.leadingAnchor.constraint(equalTo: segmentContorl.leadingAnchor).isActive = true
        drawingView.trailingAnchor.constraint(equalTo: segmentContorl.trailingAnchor).isActive = true
        drawingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print(drawingView.frame.size.width)
        barWidth = drawingView.frame.size.width / 100
        print(barWidth)
        generateRandomArray()
    }
    
    func sort(){
        switch segmentContorl.selectedSegmentIndex {
        case 0:
            insertSort()
            break
        case 1:
            numberArray = quicksort(numberArray)
            print(numberArray)
            break
        default:
            break
        }
//        let index = Int(arc4random_uniform(100))
//        print(index)
//        let value = CGFloat(arc4random_uniform(100))
//        print(value)
//        updateValue(index: index, value: value)
    }
    
    func reset(){
        numberArray.removeAll()
        layerArray.removeAll()
        drawingView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        generateRandomArray()
    }
    
    func generateRandomArray(){
        for index in 0...99 {
            let number = CGFloat(arc4random_uniform(100))
            numberArray.append(number)
            
            let path = UIBezierPath()
            let startPoint = CGPoint(x: barWidth * CGFloat(index) + barWidth / 2 , y: drawingView.frame.size.height)
            path.move(to: startPoint)
            path.addLine(to: CGPoint(x: startPoint.x, y: 0))
            
            let barLayer = CAShapeLayer()
            barLayer.path = path.cgPath
            barLayer.lineWidth = barWidth - 1
            barLayer.strokeColor = UIColor.blue.cgColor
            barLayer.strokeStart = 0
            barLayer.strokeEnd = number / 100
            drawingView.layer.addSublayer(barLayer)
            layerArray.append(barLayer)
        }
    }
    
    func updateValue(index: Int, value: CGFloat){
        numberArray[index] = value
        self.layerArray[index].strokeEnd = value / 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Sorting
    
    func swap(firstIndex: Int, secondIndex: Int){
        let temp = numberArray[firstIndex]
        updateValue(index: firstIndex, value: numberArray[secondIndex])
        updateValue(index: secondIndex, value: temp)
    }
    
    func insertSort(){
        let now = DispatchTime.now()
        for index in 1 ... numberArray.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: now + Double(index - 1) * 0.02, execute: {
                var tempIndex = index
                let tempValue = self.numberArray[index]
                while tempIndex > 0 && self.numberArray[tempIndex - 1] > tempValue {
                    self.updateValue(index: tempIndex, value: self.numberArray[tempIndex - 1])
                    tempIndex = tempIndex - 1
                }
                self.updateValue(index: tempIndex, value: tempValue)
            })
        }
    }
    
    func quicksort<T: Comparable>(_ a: [T]) -> [T] {
        guard a.count > 1 else { return a }
        
        let pivot = a[a.count/2]
        let less = a.filter { $0 < pivot }
        let equal = a.filter { $0 == pivot }
        let greater = a.filter { $0 > pivot }
        
        return quicksort(less) + equal + quicksort(greater)
    }
}

