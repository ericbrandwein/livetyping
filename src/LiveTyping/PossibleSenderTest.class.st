Class {
	#name : #PossibleSenderTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #tests }
PossibleSenderTest >> test01StringVersionBeginsWithPossible [

	self assert: 
		((PossibleSender in: self class>>thisContext selector withPossibleMessageSends: #()) stringVersion 
		beginsWith: PossibleSender possibleSenderStringVersionHeader)
]
