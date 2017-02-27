//
//  CustItemListResModel.swift
//  Qadmni
//
//  Created by Prakash Sabale on 27/02/17.
//  Copyright © 2017 Qadmni. All rights reserved.
//

import Foundation
import EVReflection

public class CustItemListResModel : CustomerBaseResponseModel
{
    var itemInfoList : [ItemInfoModel] = []
    var producerLocations : [ProducerLocationModel] = []
}
