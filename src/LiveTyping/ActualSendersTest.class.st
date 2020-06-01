Class {
	#name : #ActualSendersTest,
	#superclass : #TestCase,
	#instVars : [
		'v1'
	],
	#category : #'LiveTyping-Tests'
}

{ #category : #'test data' }
ActualSendersTest class >> m1 [

	^1+1
]

{ #category : #'test data' }
ActualSendersTest >> m1 [

	"
	self initializeMethodsTypeInformation.
	self new m1.
	self returnTypesAt: #m1
	"

	^1+2
]

{ #category : #'test data' }
ActualSendersTest >> m2 [

	"
	self initializeMethodsTypeInformation.
	self new m2.
	self returnTypesAt: #m2
	"

	"This collaboraion is to avoid a quick self return - Hernan"
	1 + 1.
	
	^self
]

{ #category : #'test data' }
ActualSendersTest >> m3: anObject [

	"
	self initializeMethodsTypeInformation.
	self new m3: 1.
	self returnTypesAt: #m3:
	"

	^anObject + 2
]

{ #category : #'test data' }
ActualSendersTest >> setUp [
	super setUp.
	self class methodsDo: [ :method | method initializeTypeInformation ].
	SmallInteger initializeTypeInformation.
	"Do not remove. It is used in test20.... - Hernan"
]

{ #category : #tests }
ActualSendersTest >> test01SurelyRecognizeTypeSenderWhenSentToInstanceVariable [

	v1 := self.
	
	v1 m1.
	
	self assert: (thisContext method doesOnlySurelySend: self class>>#m1)
]

{ #category : #tests }
ActualSendersTest >> test02SurelyRecognizeTypeSenderWhenSentToTemporaryVariable [

	| t1 |
		
	t1 := self.
	
	t1 m1.
	self assert: (thisContext method doesOnlySurelySend: self class>>#m1)
]

{ #category : #tests }
ActualSendersTest >> test03SurelyRecognizeTypeSenderInACollaboration [
	
	1 + 2.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (1 class>>#+))
]

{ #category : #tests }
ActualSendersTest >> test04RecognizeTypeSendersToInstancesOfSubClasses [
	
	1 factorial.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (1 class lookupSelector: #factorial))
]

{ #category : #tests }
ActualSendersTest >> test05RecognizeTypeSendersToLiteralTrue [
	
	true & true.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (true class lookupSelector: #&))
]

{ #category : #tests }
ActualSendersTest >> test06RecognizeTypeSendersToLiteralFalse [
	
	false & true.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (false class lookupSelector: #&))
]

{ #category : #tests }
ActualSendersTest >> test07RecognizeTypeSendersToThisContext [
	
	thisContext selector.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (thisContext class lookupSelector: #selector))
]

{ #category : #tests }
ActualSendersTest >> test08RecognizeTypeSendersToSelf [
	
	self m1.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class lookupSelector: #m1))
]

{ #category : #tests }
ActualSendersTest >> test09RecognizeTypeSendersToSuper [
	
	super selector.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class lookupSelector: #selector))
]

{ #category : #tests }
ActualSendersTest >> test09_01 [
	
	"
	VariableNode>>typesIn: should return 
	1) Array with: aCompiledMethod methodClass superclass
	or
	2) Array with: aCompiledMethod methodClass 
	
	when receiver is super?"
]

{ #category : #tests }
ActualSendersTest >> test10RecognizeTypeSendersToSelfOfMessageImplementedInSuperclass [
	
	self selector.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class lookupSelector: #selector))
]

{ #category : #tests }
ActualSendersTest >> test11RecognizeTypeSendersToReturnsOfMessageSend [
		
	self m1 + 2.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (1 class lookupSelector: #+))
]

{ #category : #tests }
ActualSendersTest >> test12RecognizeTypeSendersOfChainedMessageSends [
	
	self m2 m1 + 2.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (1 class lookupSelector: #+))
]

{ #category : #tests }
ActualSendersTest >> test13RecognizeTypeSendersToReturnOfMessageSendNoMatterThePrecedence [
	
	"
	self class initializeMethodsTypeInformation.
	"
	
	(self m3: 1) + 2.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (1 class lookupSelector: #+))
]

{ #category : #tests }
ActualSendersTest >> test14RecognizeTypeSendersToClasses [
	
	ActualSendersTest m1.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class class lookupSelector: #m1))
]

{ #category : #tests }
ActualSendersTest >> test15RecognizeTypeSendersToVariablesReferencingClasses [
	
	| t1 |
	
	t1 := ActualSendersTest.
	t1 m1.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class class lookupSelector: #m1))
]

{ #category : #tests }
ActualSendersTest >> test16RecognizeTypeSendersToAnyLiteral [
	
	"
	self class initializeMethodsTypeInformation.
	"
	$a asCharacter.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: ($a class lookupSelector: #asCharacter))
]

{ #category : #tests }
ActualSendersTest >> test17CanRecognizePossibleTypeSenders [
	
	| t1 sendersCollector sureSender possibleSender |
	
	true & false.
	"This code never executes but it is here to get possible senders.
	Because it never executes there is no type info of t1 - Hernan"
	true ifFalse: [ 
		"This assigment is to avoid compilation warning - Hernan"
		t1 := 1. 
		t1 & true ].
	
	sendersCollector := self class>>thisContext selector actualSendersOf: (true class lookupSelector: #&).
	
	self assert: sendersCollector hasSureMessageSends.
	self assert: sendersCollector sureMessageSends size equals: 1.
	sureSender := sendersCollector sureMessageSends anyOne.
	
	self assert: sureSender isMessageNode.
	self assert: sureSender receiver isTruePseudoVariable.
	self assert: sureSender arguments anyOne isFalsePseudoVariable.
	
	self assert: sendersCollector hasPossibleMessageSends.
	self assert: sendersCollector possibleMessageSends size equals: 1.
	possibleSender := sendersCollector possibleMessageSends anyOne key.
	
	self assert: possibleSender isMessageNode.
	self assert: possibleSender receiver key equals: 't1'.
	self assert: possibleSender arguments anyOne isTruePseudoVariable.
	
]

{ #category : #tests }
ActualSendersTest >> test18RecognizeTypeSendersWhenReturnTypeIsSelfType [
	
	1 yourself + 2.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (1 class lookupSelector: #+)).

]

{ #category : #tests }
ActualSendersTest >> test19RecognizeTypeSendersWhenReturnTypeIsClassType [
	
	self class m1.
	
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class class lookupSelector: #m1)).
	self deny: (self class>>thisContext selector doesOnlySurelySend: (self class lookupSelector: #m1)).

]

{ #category : #tests }
ActualSendersTest >> test20SurelySendWhenReceiverTypeIsSuperclassOfImplementorType [
	
	self assert: (self class superclass>>#runCase doesOnlySurelySend: self class>>#setUp).
	
]

{ #category : #tests }
ActualSendersTest >> test21ActualSendersWorksWithCascadeMessageSends [
	
	self 
		m1;
		m2.
		
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class>>#m1)).
	self assert: (self class>>thisContext selector doesOnlySurelySend: (self class>>#m2)).
]
