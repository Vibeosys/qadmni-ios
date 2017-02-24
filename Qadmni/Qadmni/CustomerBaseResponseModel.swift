//
//  CustomerBaseResponseModel.swift
//  Qadmni
//
//  Created by Prakash Sabale on 14/02/17.
//  Copyright © 2017 Qadmni. All rights reserved.
//

import Foundation
import EVReflection

public class CustomerBaseResponseModel : EVObject
{
    var errorCode: Int32 = 0
    var message : String = ""
    var data : String = ""

}
