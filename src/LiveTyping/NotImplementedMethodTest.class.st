Class {
	#name : #NotImplementedMethodTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #tests }
NotImplementedMethodTest >> test01ActualSendersIsEmpty [

	self assert: ((NotImplementedMethod class: self class selector: #none) actualSendersOf: self class>>thisContext selector) isEmpty
]

{ #category : #tests }
NotImplementedMethodTest >> test02CategoryIsNil [

	self assert: (NotImplementedMethod class: self class selector: #none) category isNil
]

{ #category : #tests }
NotImplementedMethodTest >> test03CompiledMethodSignalsError [

	| notImplementedMethod |
	
	notImplementedMethod := NotImplementedMethod class: self class selector: #none.
	self 
		should: [ notImplementedMethod compiledMethod ]
		raise: Error
		withMessageText: Dictionary keyNotFoundErrorDescription 
]

{ #category : #tests }
NotImplementedMethodTest >> test04CompiledMethodIfAbsentEvaluatesIfAbsentBlock [

	| notImplementedMethod |
	
	notImplementedMethod := NotImplementedMethod class: self class selector: #none.
	self assert: (notImplementedMethod compiledMethodIfAbsent: [ true ])
	
]

{ #category : #tests }
NotImplementedMethodTest >> test05doesOnlySurelySendReturnsFalse [

	self deny: ((NotImplementedMethod class: self class selector: #none) doesOnlySurelySend: self class>>thisContext selector) 
	
]

{ #category : #tests }
NotImplementedMethodTest >> test06dynamicTypingAutoCompleterDocumentationReturnsEmptyText [

	self assert: (NotImplementedMethod class: self class selector: #none) dynamicTypingAutoCompleterDocumentation isEmpty
]

{ #category : #tests }
NotImplementedMethodTest >> test07IsNotValid [

	self deny: (NotImplementedMethod class: self class selector: #none) isValid
]

{ #category : #tests }
NotImplementedMethodTest >> test08liveTypingAutoCompleterDocumentationReturnsEmptyText [

	self assert: (NotImplementedMethod class: self class selector: #none) liveTypingAutoCompleterDocumentation isEmpty
]

{ #category : #tests }
NotImplementedMethodTest >> test09rangesOASentSelectorWhenSendToReceiverTypesIsEmpty [

	self assert: ((NotImplementedMethod class: self class selector: #none) rangesOf: #size whenSendTo: { OrderedCollection })
 isEmpty
]

{ #category : #tests }
NotImplementedMethodTest >> test10FailsWhenAsItsSourceCode [

	| notImplementedMethod |
	
	notImplementedMethod := NotImplementedMethod class: self class selector: #none.
	self 
		should: [ notImplementedMethod sourceCode ]
		raise: Error
		withMessageText: Dictionary keyNotFoundErrorDescription 
]

{ #category : #tests }
NotImplementedMethodTest >> test11StringVersionStartsWithNotImplemented [

	self assert: ((NotImplementedMethod class: self class selector: #none) stringVersion beginsWith: NotImplementedMethod notImplementedStringVersionHeader)
	
]
