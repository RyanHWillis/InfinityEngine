// InfinityEngine
//
// Copyright Ryan Willis (c) 2016
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit


//** Infinity Engine **//

let kCellHeight:CGFloat             = 50.0
let kBufferHeight:CGFloat           = 350.0
let kPlaceHolderCellCount:Int       = 14


/**
 Constructural modifers that change behavior.
 
 - parameter infiniteScroll:        Whether our data is paged, or delivered all at first response payload.
 - parameter forceReload:           If data should append, or reload the entire view.

 */

public struct InfinityModifers {
    let refreshControl:Bool?
    
    public init(refreshControl defaultControl: Bool? = true) {
        self.refreshControl = defaultControl
    }
}

/**
 Constructural sources for abstract data
 
 - func infinityDidSelectItemAtIndexPath:        Get the selected infinity cell at its current index.
 - func infinityData:                            Retreives the appropaite data to feed into the framework
 
 */


public protocol InfinityDataSource: InfinityDataEngineDelegateOptional {}

@objc public protocol InfinityDataEngineDelegateOptional: class {
    @objc optional func infinintyDataResponse(withData data:[AnyObject]?)
}
