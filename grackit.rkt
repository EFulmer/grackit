#lang racket

(require openssl/sha1)

; full header of objects: "blob {content.bytesize)\0"
; what's stored is the header IMMEDIATELY followed by the file contents.
(define (make-object-header file-name)
  (let* ([in-port (open-input-file file-name #:mode 'binary)]
         [bs      (port->bytes in-port)]
         [byte-length (bytes-length bs)])
    (string-append "blob " (number->string byte-length) "\0")))

(define (prepare file-name)
  (let* ([header (make-object-header file-name)]
         [contents (file->string file-name)]
         [to-hash (string-append header contents)])
    (string->bytes/utf-8 to-hash)))

; TODO: handle the case of the file not existing.
(define (hash-object file-name)
  (sha1-bytes (open-input-bytes (prepare file-name))))

(println (make-object-header "grackit.rkt"))
(println (bytes->hex-string (hash-object "grackit.rkt")))