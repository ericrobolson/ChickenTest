(import scheme (chicken file))

;; An individual test case.
(define (test test-case actual expected)
    (list 
        ;; success or fail
        (cond 
            ;; check if both strings and equal
            (
                (and 
                    (and (string? actual) (string? expected))
                    (equal? actual expected)
            ) 'success)
            ((eq? actual expected) 'success)
            (else 'fail))
        test-case
        actual 
        expected))

;; A test module.
(define (testing method first . rest)
    (print "----------------------------")
    (print "Testing '" method "'")

    (let ((cases (cons first rest)))
        (map (lambda (case)
            (let (
                (result (car case))
                (test-case (car (cdr case)))
                (actual (car (cdr (cdr case))))
                (expected (car (cdr (cdr (cdr case)))))
                )
                (cond 
                    ((null? case) (error "you passed a null value!"))
                    ((eq? result 'fail) 
                        (print "\tfail - " test-case)
                        (print "\t\t wanted: " expected)
                        (print "\t\t actual: " actual)
                        )
                    (else (print "\tsuccess - " test-case)))
                ))
            cases))
    (print "----------------------------"))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; FILE TRAVERSAL  ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Given a path, traverse and return all files in a recursive fashion.
(define (traverse file) 
    (cond
        ((null? file) 
            (map (lambda (f) (traverse f)) (directory)))
        ((directory-exists? file) 
            (map (lambda (f) (traverse (string-append file "/" f))) (directory file)))
        (else file)))

;; Recursively crawls all files + directories.
(define (crawl) 
    (flatten (traverse '())))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; HELPER METHODS ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Checks if the given string ends with the given suffix
(define (ends-with? string suffix)
    (cond
        ((and 
            (string? string) 
            (string? suffix) 
            (>= (string-length string) (string-length suffix))
            )
            (let (
                (end (substring string (- (string-length string) (string-length suffix)) (string-length string)))
                )
            (equal? suffix end))) 
        (else #f)
    ))

;; Checks if the given file is a test file
(define (is-test-file? file)
    (cond
        ((string? file) (ends-with? file ".test.scm" ))
        (else #f)
    ))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; EXECUTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (execute-tests)
    (map (lambda (f) (if (is-test-file? f) (load f)))
        (crawl)))

(execute-tests)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; TESTS ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; (testing ends-with? 
;     (test "non-string input returns #f"
;         (ends-with? 1 2) 
;         #f)
;     (test "'a test string' and 'foo' returns #f"
;         (ends-with? "a test string" "foo")
;         #f)
;     (test "'foo string' and 'foo' returns #f"
;         (ends-with? "foo string" "foo")
;         #f)
;     (test "'foo string' and 'string' returns #t"
;         (ends-with? "foo string" "string")
;         #t)
; )
; 
; (testing is-test-file? 
;     (test "nil returns false"
;         (is-test-file? '()) 
;         #f)
;     (test "'regular-file.scm' returns false"
;         (is-test-file? "regular-file.scm") 
;         #f)
;     (test "non-string returns false"
;         (is-test-file? 1) 
;         #f)
;     (test "'passing-file.test.scm' returns true"
;         (is-test-file? "passing-file.test.scm") 
;         #t)
; )