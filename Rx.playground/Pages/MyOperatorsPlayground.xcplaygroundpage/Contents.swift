import RxSwift
import RxCocoa
import RxTest

public enum MyError: Error {
    case test
}

/*:
 ## CombineLatest & Zip
 Pytanie: Jak łączone będą wyniki
 */

typealias CombiningClosure = (
    (Observable<String>, Observable<String>)
    -> Observable<String>)

func combiningEx1(combineOrZip: CombiningClosure) {
    let disposeBag = DisposeBag()
    let subjectLetters = PublishSubject<String>()
    let subjectDigits = PublishSubject<String>()
    
    let combined = combineOrZip(subjectLetters.asObservable(),
                                    subjectDigits.asObservable())
    combined.subscribe(onNext: { print( $0)})
    subjectLetters.onNext("A")
    subjectLetters.onNext("B")
    subjectLetters.onNext("C")
    subjectDigits.onNext("1")
    subjectDigits.onNext("2")
    subjectDigits.onNext("3")
    subjectDigits.onNext("4")
    subjectDigits.onNext("5")
    subjectLetters.onNext("D")
}

example("My combineLatest ex1 14dec2016") {
    let combineOrZip: CombiningClosure = {
        Observable.combineLatest($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx1(combineOrZip: combineOrZip)
}

example("My zip ex1 14dec2016") {
    let combineOrZip: CombiningClosure = {
        Observable.zip($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx1(combineOrZip: combineOrZip)
}

func combiningEx2(combineOrZip: CombiningClosure) {
    let disposeBag = DisposeBag()
    let subjectLetters = PublishSubject<String>()
    let subjectDigits = PublishSubject<String>()
    
    let combined = combineOrZip(subjectLetters.asObservable(),
                                    subjectDigits.asObservable())
    combined.subscribe(onNext: { print( $0)},
                       onError: { print( "Error \($0)")})
    subjectLetters.onNext("A")
    subjectDigits.onNext("1")
    subjectDigits.onNext("2")
    subjectDigits.onError(MyError.test)
    subjectDigits.onNext("3")
    subjectLetters.onNext("B")
}

example("My combineLatest ex2 14dec2016") {
    let combineOrZip: CombiningClosure = {
        Observable.combineLatest($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx2(combineOrZip: combineOrZip)
}

example("My zip ex2 14dec2016") {
    let combineOrZip: CombiningClosure = {
        Observable.zip($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx2(combineOrZip: combineOrZip)
}

/*:
 ## dispose
 Pytania:
 1. Co zostanie wypisane na ekran?
 2. co zostanie wypisane na ekran, gdy odkomentujemy disposable.dispose()?
 */

example("My nil disposable 18dec2016") {
    
    
    let subject = PublishSubject<Int>()
    let disposable = subject
        .subscribe(onNext: { print("Next: \($0)")},
                   onCompleted: { print("Completed") },
                   onDisposed: { print("Disposed")})
    
    
    subject.onNext(1)
    //disposable.dispose()
    subject.onNext(2)
    subject.onCompleted()
    subject.onNext(3)
    
    //RunLoop.current.run(until: Date().addingTimeInterval(0.05))
}

/*:
 ## Concat
 Pytania:
 1. Czy jabłko zostanie wypisane na ekran?
 2. Świnia, królik, kot. Które zostanie wypisane na ekran?
 3. Co stanie się, kiedy zamienię concat na merge?
 */
example("RxExample:concat") {
    let disposeBag = DisposeBag()
    
    let subject1 = BehaviorSubject(value: "🍎")
    let subject2 = BehaviorSubject(value: "🐶")
    
    let variable = Variable(subject1)
    
    variable.asObservable()
        .concat()
        .subscribe { print($0) }
        .addDisposableTo(disposeBag)
    
    subject1.onNext("🍐")
    subject1.onNext("🍊")
    
    variable.value = subject2
    
    subject2.onNext("🐖?")
    subject2.onNext("🐇?")
    subject2.onNext("🐱?")
    
    subject1.onCompleted()
    
    subject2.onNext("🐭")
}

/*:
 ## asDriver problem
 Pytanie: Co zostanie wypisane na ekran?
 */

example("Slack: scotegg 13dec2016") {
    
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<Int>()
    subject
        .asDriver(onErrorRecover: { (error) in
            print("Error:", error)
            return Driver.just(1000)
        })
        .drive(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onError(MyError.test)
    
    subject.onNext(3)
    //RunLoop.current.run(until: Date().addingTimeInterval(0.05))
}

/*:
 ## Scan, ToArray
 Pytania:
 1.
 
 public static IObservable<Tuple<TSource, TSource>>
 PairWithPrevious<TSource>(this IObservable<TSource> source) {
 return source.Scan(
 Tuple.Create(default(TSource), default(TSource)),
 (acc, current) => Tuple.Create(acc.Item2, current));
 }
 */


example("My scan & toArray 18dec2016") {
    let disposeBag = DisposeBag()
    
    let subjectLetters = PublishSubject<String>()
    subjectLetters
        .catchErrorJustReturn("ERR")
        .scan([String](), accumulator: { (acc, val) -> [String] in
            return acc + [val]
        })
        .asObservable()
        .subscribe(onNext: { print( $0)},
                   onError: { print( "Error \($0)")})
        .addDisposableTo(disposeBag)
    subjectLetters.onNext("A")
    subjectLetters.onNext("B")
    subjectLetters.onNext("C")
    subjectLetters.onError(MyError.test)
    subjectLetters.onNext("D")
    subjectLetters.onCompleted()
}
