Class {
	#name : #ActualMessageSendsCollector,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'sent',
		'toAnalize',
		'sentSelector',
		'sentMethodClass',
		'sureMessageSends',
		'possibleMessageSends',
		'toAnalizeMethodClass',
		'isToAnalizeInSuperclass'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
ActualMessageSendsCollector class >> in: toAnalizeCompiledMethod of: aSentCompiledMethod [ 
	
	^self new initializeIn: toAnalizeCompiledMethod of: aSentCompiledMethod 

]

{ #category : #collecting }
ActualMessageSendsCollector >> analizeMessageSend: aMessageNode [
	
	 | receiverTypes incompleteTypeInfoReasons |

	incompleteTypeInfoReasons := Set new.
	receiverTypes := aMessageNode receiver typesIn: toAnalize addingIncompleteTypeInfoTo: incompleteTypeInfoReasons.			
	
	receiverTypes isEmpty
		ifTrue: [ possibleMessageSends add: aMessageNode->(Array with: 'Could not get receiver''s type info') ]
		ifFalse: [ 
			"A method can have sure message sends and possible message sends! - Hernan"
			(self isSureMessageSendFor: receiverTypes) ifTrue: [ sureMessageSends add: aMessageNode ].
			incompleteTypeInfoReasons notEmpty ifTrue: [ possibleMessageSends add: aMessageNode->incompleteTypeInfoReasons ]]
]

{ #category : #testing }
ActualMessageSendsCollector >> hasOnlySureMessageSends [

	^sureMessageSends notEmpty and: [ possibleMessageSends isEmpty ]
]

{ #category : #testing }
ActualMessageSendsCollector >> hasPossibleMessageSends [

	^ possibleMessageSends notEmpty
]

{ #category : #testing }
ActualMessageSendsCollector >> hasSureMessageSends [

	^sureMessageSends notEmpty
]

{ #category : #initialization }
ActualMessageSendsCollector >> initializeIn: toAnalizeCompiledMethod of: aSentCompiledMethod [ 

	toAnalize := toAnalizeCompiledMethod.
	toAnalizeMethodClass := toAnalizeCompiledMethod methodClass.
	sent := aSentCompiledMethod.
	sentSelector := sent selector.
	sentMethodClass := sent methodClass.
	isToAnalizeInSuperclass := sentMethodClass includesBehavior: toAnalizeMethodClass.
	
	sureMessageSends := OrderedCollection new.
	possibleMessageSends := OrderedCollection new.
]

{ #category : #collecting }
ActualMessageSendsCollector >> isSureMessageSendFor: receiverTypes [
	
	^receiverTypes anySatisfy: [ :aReceiverType | 
		(aReceiverType includesBehavior: sentMethodClass) or: [ isToAnalizeInSuperclass and: [ aReceiverType = toAnalizeMethodClass ]]]
]

{ #category : #accessing }
ActualMessageSendsCollector >> possibleMessageSends [
	
	^possibleMessageSends 
]

{ #category : #accessing }
ActualMessageSendsCollector >> sureMessageSends [
	
	^sureMessageSends
]

{ #category : #visiting }
ActualMessageSendsCollector >> visitMessageNode: aMessageNode [
	
	(aMessageNode selector = sentSelector) ifTrue: [ self analizeMessageSend: aMessageNode ].
		
	^super visitMessageNode: aMessageNode 
	
]

{ #category : #visiting }
ActualMessageSendsCollector >> visitMessageNodeInCascade: aMessageNode [
	
	(aMessageNode selector isNamed: sentSelector) ifTrue: [ self analizeMessageSend: aMessageNode ].
		
	^super visitMessageNodeInCascade: aMessageNode 
	
]
