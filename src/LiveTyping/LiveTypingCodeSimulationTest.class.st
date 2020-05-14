Class {
	#name : #LiveTypingCodeSimulationTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> assignmentToLocalTemporary [
	
	| temporary |
	
	temporary := 'xx'.
	
	^temporary 
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> assignmentToRemoteTemporary [
	
	| localTemp remoteTemp |
	
	localTemp := 1.
	
	[ remoteTemp := localTemp printString ] value.
	
	^remoteTemp 
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> blockReturn [

	[ 'hello' ] value.
	
	^10
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> blockWithParameter: parameter1 [

	[ :blockParameter | blockParameter size ] value: 'hello'.
	
	^parameter1 
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> parameter1: parameter1 parameter2: parameter2 [

	| localTemp |
	
	localTemp := 1/2.
	
	^localTemp + parameter1 + parameter2 size
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> returnConstant [ 

	^'Hello'
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> returnFromClosure: aValue [

	[ ^aValue ] value
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> returnReceiver [
	
	"It does not have to be a quick self return - Hernan"
	
	1 + 1.
	
	^self
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> returnTop: aValue [

	1 + 1.
	
	^aValue
]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> returnUnwind: aValue [

	[ self valueParameter: [ ^aValue] ] ensure: [ 'hello' ] 
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test01KeepTypesOfLocalTemporariesI [

	| method types |
	
	method := self class>>#assignmentToLocalTemporary.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ self assignmentToLocalTemporary ].
	
	types := method typesOfVariableNamed: 'temporary'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: String).
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test02KeepTypesOfRemoteTemporaries [

	| method types |
	
	method := self class>>#assignmentToRemoteTemporary.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ self assignmentToRemoteTemporary ].
	
	types := method typesOfVariableNamed: 'remoteTemp'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: String).
	
	types := method typesOfVariableNamed: 'localTemp'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test03KeepTypesOfParameters [

	| method types result |
	
	method := self class>>#parameter1:parameter2:.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := self parameter1: 1 parameter2: 'Hello' ].
	
	self assert: (1/2 + 1 + 'hello' size) equals: result.
	
	types := method typesOfVariableNamed: 'parameter1'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).
	
	types := method typesOfVariableNamed: 'parameter2'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: String).
	
	types := method typesOfVariableNamed: 'localTemp'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: Fraction).
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test04KeepReturnTopTypes [

	| method types result |
	
	method := self class>>#returnTop:.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := self returnTop: 1 ].
	
	self assert: 1 equals: result.
	
	types := method returnTypes.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).
	
	
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test05KeepReturnConstantTypes [

	| method types result |
	
	method := self class>>#returnConstant.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := self returnConstant ].
		
	types := method returnTypes.
	
	self assert: 1 equals: types size.
	self assert: (types includes: String).

	"It has to be after getting the types because it changes the return types - Hernan"	
	self assert: self returnConstant equals: result.

]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test06KeepReturnReceiverTypes [

	| method types result |
	
	method := self class>>#returnReceiver.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := self returnReceiver ].
		
	self assert: self equals: result.
	
	types := method returnTypes.
	
	self assert: 1 equals: types size.
	self assert: (types includes: self class).

	
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test07KeepReturnFromClosureTypes [

	| method types result |
	
	method := self class>>#returnFromClosure:.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := self returnFromClosure: 10 ].
		
	self assert: 10 equals: result.
	
	types := method returnTypes.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).

	
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test08KeepReturnTypeWhenUnwind [

	| method types result |
	
	method := self class>>#returnUnwind:.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := self returnUnwind: 10 ].
	
	self assert: 10 equals: result.
	
	types := method returnTypes.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).


]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test09BlockReturnDoesNotAffectMethodReturn [

	| method types result |
	
	method := self class>>#blockReturn.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := self blockReturn ].
	
	self assert: 10 equals: result.
	
	types := method returnTypes.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).


]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test10KeepTypesOfParametersWhenSendingValueWithArguments [

	| method types result |
	
	method := self class>>#parameter1:parameter2:.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ result := method valueWithReceiver: self arguments: { 1. 'hello' }].
	
	self assert: (1/2 + 1 + 'hello' size) equals: result.
	
	types := method typesOfVariableNamed: 'parameter1'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).
	
	types := method typesOfVariableNamed: 'parameter2'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: String).
	
	types := method typesOfVariableNamed: 'localTemp'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: Fraction).
]

{ #category : #tests }
LiveTypingCodeSimulationTest >> test11BlockWithParametersDoNotAffectMethodParameters [

	| method types |
	
	method := self class>>#blockWithParameter:.
	method initializeTypeInformation.
	
	ContextPart runSimulated: [ self blockWithParameter: 10].
	
	types := method typesOfVariableNamed: 'parameter1'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger).
	

]

{ #category : #'test support' }
LiveTypingCodeSimulationTest >> valueParameter: aBlock [

	aBlock value.
	
]
