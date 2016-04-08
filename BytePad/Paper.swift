//
//  Paper.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 07/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import Foundation


class Paper {
    private var _name : String
    private var _exam : String
    private var _url: String
    
    init(name: String, exam: String, url:String) {
        self._exam = exam
        self._name = name
        self._url = url
    }
    
    var name: String {
        return self._name
    }
    
    var exam: String {
        return self._exam
    }
    
    var url: String {
        return self._url
    }
    
    
}