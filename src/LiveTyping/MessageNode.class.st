Class {
	#name : #MessageNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
MessageNode >> identifierPrintString [
	
	^selector identifierPrintString 
]

{ #category : #'as yet unclassified' }
MessageNode >> isAnd [
	
	^self selectorSymbol = #and:
]

{ #category : #'as yet unclassified' }
MessageNode >> isAnyKindOfIf [
	
	| selectorSymbol |
	
	selectorSymbol := self selectorSymbol.
	
	^ selectorSymbol = #ifTrue:ifFalse: 
		or: [ selectorSymbol = #ifTrue: 
		or: [ selectorSymbol = #ifFalse: 
		or: [ selectorSymbol = #ifFalse:ifTrue ]]]
		
]

{ #category : #'as yet unclassified' }
MessageNode >> isClassEqualOrIdenticalToObjectClass [
	
	^self isEqualOrIdentical and: [ self isReceiverLiteralBehavior and: [ self isFirstArgumentClassMessageSend ]]
]

{ #category : #'as yet unclassified' }
MessageNode >> isClassMessageSend [
	
	^self selectorSymbol = #class
]

{ #category : #'as yet unclassified' }
MessageNode >> isClassNotEqualOrNotIdenticalToObjectClass [
	
	^self isNotEqualOrNotIdentical and: [ self isReceiverLiteralBehavior and: [ self isFirstArgumentClassMessageSend ]]
]

{ #category : #'as yet unclassified' }
MessageNode >> isEqualOrIdentical [
	
	^self selectorSymbol = #== or: [ self selectorSymbol = #= ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isEqualOrIdenticalToNil [
	
	^self isEqualOrIdentical and: [ self isFirstArgumentNil ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isFirstArgumentClassMessageSend [
	
	^ arguments first isMessageNode and: [ arguments first isClassMessageSend ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isFirstArgumentLiteralBehavior [
	
	^arguments first isLiteralVariableNode and: [ arguments first isReferencingBehavior ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isFirstArgumentNil [
	
	^ arguments first isNilPseudoVariable 
]

{ #category : #'as yet unclassified' }
MessageNode >> isIfNil [
	
	^self selectorSymbol = #ifNil:
]

{ #category : #'as yet unclassified' }
MessageNode >> isIfNotNil [
	
	^self selectorSymbol = #ifNotNil:
]

{ #category : #'as yet unclassified' }
MessageNode >> isIfWithMessageNodeAsCondition [
	
	^self isAnyKindOfIf and: [ self receiverOrCascadeReceiver isMessageNode ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isIsKindOfWithLiteralBehavior [
	
	^self selectorSymbol = #isKindOf: and: [ self isFirstArgumentLiteralBehavior ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isIsNil [
	
	^self selectorSymbol = #isNil
]

{ #category : #'as yet unclassified' }
MessageNode >> isNilEqualOrIdenticalTo [
	
	^self isEqualOrIdentical and: [ self isReceiverNil ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isNilNotEqualOrNotIdenticalTo [
	
	^self isNotEqualOrNotIdentical and: [ self isReceiverNil ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isNotEqualOrNotIdentical [
	
	^self selectorSymbol = #~~ or: [ self selectorSymbol = #~= ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isNotEqualOrNotIdenticalToNil [
	
	^self isNotEqualOrNotIdentical and: [ self isFirstArgumentNil ]	
	
]

{ #category : #'as yet unclassified' }
MessageNode >> isNotNil [
	
	^self selectorSymbol = #notNil
]

{ #category : #'as yet unclassified' }
MessageNode >> isObjectClassEqualOrIdenticalToClass [
	
	^self isEqualOrIdentical and: [ self isReceiverClassMessageSend and: [ self isFirstArgumentLiteralBehavior ]]
		
	
]

{ #category : #'as yet unclassified' }
MessageNode >> isObjectClassNotEqualOrNotIdenticalToClass [
	
	^self isNotEqualOrNotIdentical and: [ self isReceiverClassMessageSend and: [ self isFirstArgumentLiteralBehavior ]]
		
	
]

{ #category : #'as yet unclassified' }
MessageNode >> isOr [

	^self selectorSymbol = #or:
]

{ #category : #'as yet unclassified' }
MessageNode >> isReceiverClassMessageSend [
	
	^receiver isMessageNode and: [ receiver isClassMessageSend ]

]

{ #category : #'as yet unclassified' }
MessageNode >> isReceiverLiteralBehavior [
	
	^receiver isLiteralVariableNode and: [ receiver isReferencingBehavior ]
]

{ #category : #'as yet unclassified' }
MessageNode >> isReceiverNil [
	
	^receiver isNilPseudoVariable 

]

{ #category : #'as yet unclassified' }
MessageNode >> isUnaryMessageSend [
	
	^self selectorSymbol isUnary 
]

{ #category : #'as yet unclassified' }
MessageNode >> nodeTypePrintString [

	^'message'
]

{ #category : #'as yet unclassified' }
MessageNode >> receiverOrCascadeReceiver [
	
	"When in cascade, receiver is nil and originalReceiver is the cascade receiver - Hernan"
	
	^receiver ifNil: [ originalReceiver ]
]

{ #category : #'as yet unclassified' }
MessageNode >> receiverTypesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [
	
	^self receiverTypesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: NoTypeCastApplier new
]

{ #category : #'as yet unclassified' }
MessageNode >> receiverTypesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: aTypeCastApplier [ 
	
	^self receiverOrCascadeReceiver typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: aTypeCastApplier 
]

{ #category : #'as yet unclassified' }
MessageNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^self typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: NoTypeCastApplier new
]

{ #category : #'as yet unclassified' }
MessageNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: aTypeCastApplier [ 
	
	| types sentSelector receiverTypes  |

	sentSelector := self selectorSymbol.
	receiverTypes := aTypeCastApplier receiverTypesFor: self in: aCompiledMethod addingIncompleteTypeInfoTo:  incompleteTypeInfoReasons.
	
	types := receiverTypes
		inject: Set new
		into: [ :messageReturnTypes :aReceiverType | 								
			(aReceiverType lookupSelector: sentSelector) 
				ifNil: [ incompleteTypeInfoReasons add: (
					IncompleteTypeInfoError dueToMissingImplementationOf: (MethodReference class: aReceiverType selector: sentSelector)) ]
				ifNotNil: [ :implementor | | returnTypes |
					returnTypes := implementor returnTypes.
					returnTypes isEmpty
						ifTrue: [ incompleteTypeInfoReasons add: (IncompleteTypeInfoWarning dueToNoReturnTypeOf: implementor methodReference) ]
						ifFalse: [ messageReturnTypes addAll: (returnTypes collect: [ :aType | aType asTypeFor: aReceiverType])]].
			messageReturnTypes ].
		
	^types
]
