//
//  ArrowView.swift
//  UBAuthFlow
//
//  Created by Usemobile on 23/05/19.
//

import UIKit

class ArrowView: UIView {
    
    var path: UIBezierPath!
    var sublayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.createArrow()
    }
    
    var color: UIColor = .black {
        didSet {
            self.sublayer.fillColor = self.color.cgColor
        }
    }
    
    func createArrow() {
        let arrowWidth: CGFloat = 1.75
        path = UIBezierPath()
        
        path.move(to: .init(x: 0, y: arrowWidth))
        path.addLine(to: .init(x: self.frame.size.width/2, y: self.frame.size.height))
        path.addLine(to: .init(x: self.frame.width, y: arrowWidth))
        path.addLine(to: .init(x: self.frame.width-arrowWidth, y: 0))
        path.addLine(to: .init(x: self.frame.width/2, y: self.frame.height-2*arrowWidth))
        path.addLine(to: .init(x: arrowWidth, y: 0))
        
        path.close()
        let layer = CAShapeLayer()
        layer.path = self.path.cgPath
        layer.fillColor = self.color.cgColor
        
        self.layer.addSublayer(layer)
        self.sublayer = layer
    }
    
}


