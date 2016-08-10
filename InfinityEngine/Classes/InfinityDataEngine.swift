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

/**
 Constructural Protocols that are used to power the data engine. You should not alter or be accessing these.
 */

internal protocol InfinityDataEngineDelegate: class {
    func getData(atPage page: Int, withModifiers modifiers: InfinityModifers, completion: (responsePayload: ResponsePayload) -> ())
    func buildIndexsForInsert(dataCount count: [Int]) -> [[NSIndexPath]]
    func updateControllerView(atIndexes indexes: [[NSIndexPath]]?)
    func dataEngine(responsePayload payload: ResponsePayload, withIndexPaths indexPaths: [[NSIndexPath]]?)
}

/**
 Constructs an internal NSObject, used to represents the engine room for data delegation into InfinityCollectionView & InfinityTableView.
 */

internal final class InfinityEngine: NSObject {
    
    //MARK: - Monitiors
    var page:NSInteger!
    var previousPage: NSInteger = 0
    var sessionID:String!
    var lastPageHit:Bool!
    var modifiers: InfinityModifers!
    var loading = false
    
    //MARK: - DATA
    var dataCount = [Int]()
    var delegate: InfinityDataEngineDelegate?
    
    init(infinityModifiers modifers:InfinityModifers, withDelegate delegate: InfinityDataEngineDelegate) {
        super.init()
        self.delegate = delegate
        self.modifiers = modifers
        self.resetData()
    }

    func performDataFetch() {
        
        if self.lastPageHit == true { return }
        
        self.loading = true
        self.delegate?.getData(atPage: self.page, withModifiers: self.modifiers) { (responsePayload) in
                        
            self.page = self.page + 1
            
            // Let's Check If Our Last Page Has Been Hit
            /*------------------------------------------------------------------------*/
            
            self.lastPageHit = responsePayload.lastPage
            
            // Build Indexes Depending On Results Returned
            /*------------------------------------------------------------------------*/
            var sectionIndexes:[[NSIndexPath]]?
            if !self.modifiers.forceReload {
                sectionIndexes = self.delegate?.buildIndexsForInsert(dataCount: responsePayload.count)
            }
            
            self.delegate?.dataEngine(responsePayload: responsePayload, withIndexPaths: sectionIndexes)
            
            self.delegate?.updateControllerView(atIndexes: sectionIndexes)
            
            self.loading = false            
        }
    }
    
    func responseIsValid(atPage page:Int, withReloadControl refreshControl: UIRefreshControl?, withResponsePayload response:ResponsePayload) -> Bool {
        
        // Check that the response is from the same session
        if response.session != self.sessionID {
            print("INFINITY ENGINE: - Recieving data from pre-refresh session, discarding.")
            return false
        }
        
        // Ensure our rsponse is still not the same/previous page
        if page > self.previousPage {
            
            if let refreshing = refreshControl?.refreshing where refreshing == true  {
                
                if page == 1 {
                    self.previousPage = page
                    refreshControl?.endRefreshing()
                    return true
                }
                
            } else {
                
                if page == self.previousPage + 1 {
                    self.previousPage = page
                    return true
                }
            }
            
        } else {
            print("INFINITY ENGINE: - You seem to be feeding me duplicate " +
                "pages (\(page)), that i've already processed.")
        }
        
        return false
    }
    
    func dataFactory(responsePayload:ResponsePayload) -> [Int] {
//        self.dataCount = responsePayload.count
//        
//        for (index, numb) in responsePayload.count.enumerate() {
//            self.dataCount[index] = self.dataCount[index] + numb
//        }
        
        self.dataCount = responsePayload.count

        return self.dataCount
    }
    
    func resetData() {
        self.page = 1
        self.previousPage = 0
        self.lastPageHit = false
        self.dataCount = []
        self.sessionID = self.randomAlphaNumericString()
        self.delegate?.updateControllerView(atIndexes: nil)
    }

    func splitIndexPaths(sectionIndexPaths: [[NSIndexPath]]) -> (reloadIndexPaths: [[NSIndexPath]], insertIndexPaths: [[NSIndexPath]]) {
        
        var reloadSectionIndexPaths = [[NSIndexPath]]()
        var insertSectionIndexPaths = [[NSIndexPath]]()
        
        for (index, sectionPaths) in sectionIndexPaths.enumerate() {
            
            
            var reloadIndexPaths = [NSIndexPath]()
            var insertIndexPaths = [NSIndexPath]()
            
            
            for indexPath in sectionPaths {
                if index == 0 && indexPath.row < kPlaceHolderCellCount {
                    reloadIndexPaths.append(indexPath)
                } else {
                    insertIndexPaths.append(indexPath)
                }
            }
            
            reloadSectionIndexPaths.append(reloadIndexPaths)
            insertSectionIndexPaths.append(insertIndexPaths)
        }
        
        return (reloadSectionIndexPaths, insertSectionIndexPaths)
    }
    
    func infinteScrollMonitor(scrollView:UIScrollView) {
        
        if self.loading { return }
        
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distance = scrollView.contentSize.height - contentYOffset
        
        if distance < height + kBufferHeight {
            self.performDataFetch()
        }
    }
    
    func randomAlphaNumericString() -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<100) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}