%%%
%%% Utility for defining new grob types
%%%

#(define (add-grob-definition grob-name grob-entry)
  (let* ((meta-entry   (assoc-get 'meta grob-entry))
	 (class        (assoc-get 'class meta-entry))
	 (ifaces-entry (assoc-get 'interfaces meta-entry)))
   (set-object-property! grob-name 'translation-type? ly:grob-properties?)
   (set-object-property! grob-name 'is-grob? #t)
   (set! ifaces-entry (append (case class
			       ((Item) '(item-interface))
			       ((Spanner) '(spanner-interface))
			       ((Paper_column) '((item-interface
						  paper-column-interface)))
			       ((System) '((system-interface
					    spanner-interface)))
			       (else '(unknown-interface)))
		       ifaces-entry))
   (set! ifaces-entry (uniq-list (sort ifaces-entry symbol<?)))
   (set! ifaces-entry (cons 'grob-interface ifaces-entry))
   (set! meta-entry (assoc-set! meta-entry 'name grob-name))
   (set! meta-entry (assoc-set! meta-entry 'interfaces
		     ifaces-entry))
   (set! grob-entry (assoc-set! grob-entry 'meta meta-entry))
   (set! all-grob-descriptions
    (cons (cons grob-name grob-entry)
     all-grob-descriptions))))

#(define (define-grob-property symbol type? description)
  (if (not (equal? (object-property symbol 'backend-doc) #f))
      (ly:error (_ "symbol ~S redefined") symbol))

  (set-object-property! symbol 'backend-type? type?)
  (set-object-property! symbol 'backend-doc description))
