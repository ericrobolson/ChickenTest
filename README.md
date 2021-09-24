A unit testing framework for Chicken Scheme. 

Usage
* Copy this file to the top level of your Scheme project
* Code Scheme files
* Add a `your_file.test.scm` containing tests
* Execute `unit-test.scm` to recursively iterate and run all `*.test.scm` files


Example tests:
```
;; example.test.scm
(testing ends-with? 
    (test "non-string input returns #f"
        (ends-with? 1 2) 
        #f)
    (test "'a test string' and 'foo' returns #f"
        (ends-with? "a test string" "foo")
        #f)
    (test "'foo string' and 'foo' returns #f"
        (ends-with? "foo string" "foo")
        #f)
    (test "'foo string' and 'string' returns #t"
        (ends-with? "foo string" "string")
        #t)
)

(testing is-test-file? 
    (test "nil returns false"
        (is-test-file? '()) 
        #f)
    (test "'regular-file.scm' returns false"
        (is-test-file? "regular-file.scm") 
        #f)
    (test "non-string returns false"
        (is-test-file? 1) 
        #f)
    (test "'passing-file.test.scm' returns true"
        (is-test-file? "passing-file.test.scm") 
        #t)
)
```