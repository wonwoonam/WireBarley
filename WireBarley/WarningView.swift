//
//  WarningView.swift
//  WireBarley
//
//  Created by Won Woo Nam on 2020/12/16.
import Foundation
import UIKit

 
class WarningView : UIView{
  
    
    var popUpView : UIView = {
        let pop = UIView()
            pop.frame = CGRect(x: 0 , y: 0, width: 300, height: 180)
            pop.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            pop.layer.cornerRadius = 5
            pop.clipsToBounds = true
            return pop
        }()
      
        
        var codeTitle : UILabel = {
            let label = UILabel()
            label.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            label.text = "송금액이 바르지 않습니다."
            label.numberOfLines = 2
            label.textAlignment = .center
            return label
        }()
        
        var okayButton : UIButton = {
            let btn = UIButton()
            btn.backgroundColor = UIColor(red: 57/255, green: 199/255, blue: 181/255, alpha: 1.0)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitle("확인", for: .normal)
            
            
            
            return btn
        }()
        
        var cancelButton : UIButton = {
            let btn = UIButton()
            btn.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
            btn.setTitle("취소", for: .normal)
            
            btn.setTitleColor(UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0), for: .normal)
            
            return btn
        }()
    
        var extraButton : UIButton = {
            let btn = UIButton()
            btn.backgroundColor = UIColor(red: 57/255, green: 199/255, blue: 181/255, alpha: 1.0)
            btn.setTitle("확인", for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.isEnabled = true
            btn.adjustsImageWhenHighlighted = true
            //btn.showsTouchWhenHighlighted = true
        
            return btn
        }()
        
        let defaults = UserDefaults.standard
        

      
        
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  
        //popUpView.frame = CGRect(x: self.frame.width/2 , y: self.bounds.size.height , width: 300, height: 180)
        codeTitle.frame = CGRect(x: 0, y: 0, width: popUpView.frame.size.width, height: 117)
        okayButton.frame = CGRect(x: 0, y: 117, width: popUpView.frame.size.width/2, height: popUpView.frame.size.height - 117)
        cancelButton.frame = CGRect(x: okayButton.frame.size.width, y: 117, width: okayButton.frame.size.width, height: popUpView.frame.size.height - 117)
        extraButton.frame = CGRect(x: 0, y: 117, width: popUpView.frame.size.width, height: popUpView.frame.size.height - 117)
        
        popUpView.addSubview(codeTitle)
        popUpView.addSubview(extraButton)
        //popUpView.addSubview(extraButton)
            
        
        addSubview(popUpView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
