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
 
  - parameter data: For streets or trails.
  - parameter count: For long journeys.
  - parameter lastPage: For casual trips around town.
  - parameter perPage: For general-purpose transportation.
  - parameter total: For general-purpose transportation.
 */

public struct ResponsePayload {
    
    let data: [AnyObject]
    let count: Int
    let lastPage: Bool
    let perPage: Int
    let total: Int
    let page: Int
    let session: String
    
    public init(data: [AnyObject], count: Int, lastPage: Bool, perPage: Int, total: Int, page: Int, session: String) {
        self.data = data
        self.count = count
        self.lastPage = lastPage
        self.perPage = perPage
        self.total = total
        self.page = page
        self.session = session
    }
}