// InfinityEngine
//
// Copyright (c) 2016
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

let kLoadingCellHeight:CGFloat      = 50.0
let kBufferItems:Int                = 10
let kPlaceHolderCellCount:Int       = 4

/**
 Used to represent what the paging request for the next response payload to InfinityEngine should be based on.
 
 - Row: In Consideration to 'Buffer' - item are loaded based on number of items within a section.
 - Section: In Consideration to 'Buffer' - item are loaded based on number of sections passed.
 
 */

public enum IndexType {
    case Row
    case Section
}

/**
 Constructural modifers that change behavior.
 
 - parameter infiniteScroll:        Whether our data is paged, or delivered all at first response payload.
 - parameter forceReload:           If data should append, or reload the entire view.
 - parameter indexedBy:             Represents what paging request should be based on.
 - parameter uriSuffix:             Appends to a URI.
 - parameter requestParamters:      Populates request form data.

 */

public struct InfinityModifers {
    let infiniteScroll:Bool!
    let forceReload:Bool!
    let indexedBy:IndexType!
    let uriSuffix:String?
    let requestParamters:[String : AnyObject]?
    
    init(infiniteScroll infinite: Bool! = true, forceReload force: Bool! = false,
                        indexedBy type: IndexType = .Row, uriSuffix suffix: String? = nil,
                                  requestParamters params: [String : AnyObject]? = nil) {
        
        self.infiniteScroll = infinite
        self.forceReload = force
        self.indexedBy = type
        self.uriSuffix = suffix
        self.requestParamters = params
    }
}

/**
 Constructural modifers that change behavior.
 
 - parameter infiniteScroll:        Whether our data is paged, or delivered all at first response payload.
 - parameter forceReload:           If data should append, or reload the entire view.
 - parameter indexedBy:             Represents what paging request should be based on.
 - parameter uriSuffix:             Appends to a URI.
 - parameter requestParamters:      Populates request form data.
 
 */

public protocol InfinityView: class {
    func infinityDidSelectItemAtIndexPath(indexPath: NSIndexPath)
    func infinityData(atPage page: Int, withModifiers modifiers: InfinityModifers, completion: (responsePayload: ResponsePayload) -> ())
}