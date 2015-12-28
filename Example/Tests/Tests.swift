// https://github.com/Quick/Quick

import Quick
import Nimble
import FDTake

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        context("these will pass") {
            
            it("can do maths") {
                expect(23) == 23
            }
            
            it("can read") {
                expect("🐮") == "🐮"
            }
            
            it("will eventually pass") {
                var time = "passing"
                
                dispatch_async(dispatch_get_main_queue()) {
                    time = "done"
                }
                
                waitUntil { done in
                    NSThread.sleepForTimeInterval(0.5)
                    expect(time) == "done"
                    
                    done()
                }
            }
        }
        
    }
}
