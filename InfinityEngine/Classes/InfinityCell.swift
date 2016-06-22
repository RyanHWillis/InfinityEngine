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


/**
 Constructural modifers that change behavior.
 
 - parameter cellNames:         Takes an array of strings, representing the class names of the cells you would like to use.
 - parameter loadingCellName:   Takes a string, representing the class name of the loading cell you would like to use.
 - parameter bundleIdentifier:  An optional paramter, where if set overrides the default 'mainBundle' implemtnation with an identifer of your choosing.
 
 */

public struct InfinityCells {
    let cellNames: [String]!
    let loadingCellName: String!
    let bundleIdentifier: String?
    
    public init(cellNames names: [String], loadingCellName loadingCellName: String, customBundle: String?) {
        
        self.cellNames = names
        self.loadingCellName = loadingCellName
        self.bundleIdentifier = customBundle
    }
}