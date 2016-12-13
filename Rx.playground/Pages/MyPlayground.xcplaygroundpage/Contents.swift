import RxSwift
import RxCocoa

public enum MyError: Error {
    case test
}

example("Slack: scotegg 13dec2016") {
    
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<Int>()
    subject
//        .catchErrorJustReturn(100)
        .asDriver(onErrorRecover: { (error) in
            print("Error:", error)
            return Driver.never()
            return Driver.just(1000)
        })
//        .debug()
        .drive(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
    
    subject.onNext(1)
    subject.onNext(2)
    
    subject.onError(MyError.test)
    
    subject.onNext(3)
}
