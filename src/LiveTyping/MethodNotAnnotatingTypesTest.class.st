Class {
	#name : #MethodNotAnnotatingTypesTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #tests }
MethodNotAnnotatingTypesTest >> test01CanSignalItWithAMethod [

	self 
		should: [ MethodNotAnnotatingTypes signalFor: self class >> thisContext selector ]
		raise: MethodNotAnnotatingTypes
		withExceptionDo: [ :anError |
			self assert: anError method == (self class >> thisContext selector).
			self deny: (anError messageText indexOfSubCollection: (self class >> thisContext selector) classAndSelector startingAt: 1) = 0 ]
]

{ #category : #tests }
MethodNotAnnotatingTypesTest >> test02IsResumable [

	| result |
	
	result := [ 1 + (MethodNotAnnotatingTypes signalFor: self class >> thisContext selector) ]
		on: MethodNotAnnotatingTypes
		do: [ :anError | anError resume: 2 ].
		
	self assert: 3 equals: result
]
