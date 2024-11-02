//
//  SkeletonTableViewCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/3/24.
//

import UIKit
import SnapKit
import Then
import SkeletonView

class SkeletonTableViewCell: UITableViewCell {
    static let identifier = "SkeletonTableViewCell"
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 18 // 반지름을 반으로 해서 원 모양으로
        view.isSkeletonable = true
        view.skeletonCornerRadius = 18
        return view
    }()
    
    let lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
    
    let lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
    
    let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7 // 반지름을 반으로 해서 원 모양으로
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(circleView)
        contentView.addSubview(lineView1)
        contentView.addSubview(lineView2)
        contentView.addSubview(lineView3)
        contentView.addSubview(dotView)
        
        circleView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.leading.equalTo(15)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        lineView1.snp.makeConstraints { make in
            make.top.equalTo(circleView)
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.trailing.equalTo(-200)
            make.height.equalTo(13)
        }
        
        lineView2.snp.makeConstraints { make in
            make.bottom.equalTo(circleView)
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.trailing.equalTo(-40)
            make.height.equalTo(13)
        }
        
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(10)
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.trailing.equalTo(-160)
            make.height.equalTo(13)
        }
        
        dotView.snp.makeConstraints { make in
            make.top.equalTo(lineView3)
            make.leading.equalTo(lineView3.snp.trailing).offset(10)
            make.width.equalTo(39)
            make.height.equalTo(13)
        }
        
        self.isSkeletonable = true
        contentView.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
