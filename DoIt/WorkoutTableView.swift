//
//  WorkoutTableView.swift
//  DoIt
//
//  Created by Leo Reyes on 3/3/16.
//  Copyright © 2016 Leo Reyes. All rights reserved.
//

import UIKit

class WorkoutTableView: UITableView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 64, width: 375, height: 500), style: UITableViewStyle.Plain)
        self.rowHeight = 44.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
