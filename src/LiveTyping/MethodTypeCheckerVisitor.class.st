Class {
	#name : #MethodTypeCheckerVisitor,
	#superclass : #Object,
	#instVars : [
		'errors',
		'warnings',
		'methodNode',
		'actualMethod',
		'problems',
		'methodReference',
		'blockCastingApplier',
		'castingApplierBuilder'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instace creation' }
MethodTypeCheckerVisitor class >> for: aMethodReference collectingErrorsInto: anCollectionOfErrors warningsInto: aCollectionOfWarnings andProblemsInto: aCollectionOfProblems [ 

	^self new initializeFor: aMethodReference collectingErrorsInto: anCollectionOfErrors warningsInto: aCollectionOfWarnings andProblemsInto: aCollectionOfProblems 
	
]

{ #category : #problems }
MethodTypeCheckerVisitor >> addProblem: anIncompleteTypeInfoWarning node: aMessageNode [ 
	
	problems add: (TypeCheckingProblem  
			canNotDeduceReceiverTypeDueTo: anIncompleteTypeInfoWarning reasonDescription on: methodReference node: aMessageNode of: methodNode)
]

{ #category : #warnings }
MethodTypeCheckerVisitor >> addWarning: anIncompleteTypeInfoError node: aMessageNode [ 
	
	warnings add: (TypeCheckingWarning 
			canNotDeduceReceiverTypeDueTo: anIncompleteTypeInfoError reasonDescription on: methodReference node: aMessageNode of: methodNode)
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForClassEqualOrIdenticalTo: aMessageNode [
	
	^EqualsTypeCastApplierBuilder 
		to: aMessageNode receiver receiver key value 
		on: aMessageNode receiver arguments first receiver
		during: aMessageNode arguments first 
		rejectingDuring: aMessageNode arguments second
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForClassNotEqualOrNotIdenticalTo: aMessageNode [
	
	^EqualsTypeCastApplierBuilder 
		to: aMessageNode receiver receiver key value 
		on: aMessageNode receiver arguments first receiver
		during: aMessageNode arguments second 
		rejectingDuring: aMessageNode arguments first
		
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForEqualOrIdenticalToClass: aMessageNode [
	
	^EqualsTypeCastApplierBuilder 
		to: aMessageNode receiver arguments first key value
		on: aMessageNode receiver receiver receiver
		during: aMessageNode arguments first 
		rejectingDuring: aMessageNode arguments second
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForEqualOrIdenticalToNil: aMessageNode [ 
	
	| receiver |

	receiver := aMessageNode receiver receiver.
	receiver isAssignmentNode ifTrue: [ receiver := receiver variable ].
	
	^ EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: receiver 
		during: aMessageNode arguments first 
		rejectingDuring: aMessageNode arguments second

		
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForIfNil: aMessageNode [ 

	^EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: aMessageNode receiver 
		during: aMessageNode arguments first.
	
	
	
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForIfNotNil: aMessageNode [ 
	
	| receiver |

	receiver := aMessageNode receiverOrCascadeReceiver.
	receiver isAssignmentNode ifTrue: [ receiver := receiver variable ].
	
	^EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: receiver
		rejectingDuring: aMessageNode arguments first 
		
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForIfWithMessageNodeAsCondition: aMessageNode [

	| condition |
	 
	condition := aMessageNode receiverOrCascadeReceiver.
	condition isIsNil ifTrue: [^self builderForIsNilCheck: aMessageNode ].
	condition isNotNil ifTrue: [^self builderForNotNilCheck: aMessageNode ].
	
	condition isEqualOrIdenticalToNil ifTrue: [ ^self builderForEqualOrIdenticalToNil: aMessageNode ].
	condition isNilEqualOrIdenticalTo ifTrue: [ ^self builderForNilEqualOrIdenticalTo: aMessageNode ].
	condition isObjectClassEqualOrIdenticalToClass ifTrue: [ ^self builderForEqualOrIdenticalToClass: aMessageNode ].
	condition isClassEqualOrIdenticalToObjectClass ifTrue: [ ^self builderForClassEqualOrIdenticalTo: aMessageNode ].
	condition isIsKindOfWithLiteralBehavior ifTrue: [ ^self builderForIsKindOf: aMessageNode ].
	
	condition isNotEqualOrNotIdenticalToNil ifTrue: [ ^self builderForNotEqualOrNotIdenticalToNil: aMessageNode ].
	condition isNilNotEqualOrNotIdenticalTo ifTrue: [ ^self builderForNilNotEqualOrNotIdenticalTo: aMessageNode ].
	condition isObjectClassNotEqualOrNotIdenticalToClass ifTrue: [ ^self builderForNotEqualOrNotIdenticalToClass: aMessageNode ].
	condition isClassNotEqualOrNotIdenticalToObjectClass ifTrue: [ ^self builderForClassNotEqualOrNotIdenticalTo: aMessageNode ].
	
	^self newBuilderIfIsTypeCheck: condition in: aMessageNode 
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForIsKindOf: aMessageNode [ 
	
	^IsKindOfTypeCastApplierBuilder 
		to: aMessageNode receiver arguments first key value
		on: aMessageNode receiver receiver
		during: aMessageNode arguments first 
		rejectingDuring: aMessageNode arguments second
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForIsNilCheck: aMessageNode [

	^EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: aMessageNode receiver receiver
		during: aMessageNode arguments first 
		rejectingDuring: aMessageNode arguments second 

]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForNilEqualOrIdenticalTo: aMessageNode [ 
	
	^EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: aMessageNode receiver arguments first 
		during: aMessageNode arguments first 
		rejectingDuring: aMessageNode arguments second 
		
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForNilNotEqualOrNotIdenticalTo: aMessageNode [ 
	
	^EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: aMessageNode receiver arguments first 
		during: aMessageNode arguments second 
		rejectingDuring: aMessageNode arguments first 
		
		
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForNotEqualOrNotIdenticalToClass: aMessageNode [
	
	^EqualsTypeCastApplierBuilder 
		to: aMessageNode receiver arguments first key value
		on: aMessageNode receiver receiver receiver 
		during: aMessageNode arguments second 
		rejectingDuring: aMessageNode arguments first
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForNotEqualOrNotIdenticalToNil: aMessageNode [ 
	
	^EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: aMessageNode receiver receiver 
		during: aMessageNode arguments second 
		rejectingDuring: aMessageNode arguments first 
		
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> builderForNotNilCheck: aMessageNode [

	^EqualsTypeCastApplierBuilder 
		toUndefinedObjectOn: aMessageNode receiver receiver
		during: aMessageNode arguments second 
		rejectingDuring: aMessageNode arguments first 

]

{ #category : #visiting }
MethodTypeCheckerVisitor >> checkMessageSentIn: aMessageNode isImplementedInAll: receiverTypes [ 
	
	| implementorsFinder |
	
	implementorsFinder := AllActualLocalImplementors of: aMessageNode selectorSymbol forAll: receiverTypes.
	implementorsFinder value.
	
	implementorsFinder notImplementedIsEmpty ifFalse: [ 
		errors add: (TypeCheckingError on: methodReference node: aMessageNode of: methodNode notImplemented: implementorsFinder notImplemented)].

]

{ #category : #initialization }
MethodTypeCheckerVisitor >> initializeFor: aMethodReference collectingErrorsInto: aCollectionOfErrors warningsInto: aCollectionOfWarnings andProblemsInto: aCollectionOfProblems [ 
	
	methodReference := aMethodReference.
	errors := aCollectionOfErrors.
	warnings := aCollectionOfWarnings.
	problems := aCollectionOfProblems 
	
]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> newBuilderFor: aMessageNode [

	|  condition |

	aMessageNode isIfNil ifTrue: [ ^self builderForIfNil: aMessageNode ].
	aMessageNode isIfNotNil ifTrue: [ ^self builderForIfNotNil: aMessageNode ].
	aMessageNode isIfWithMessageNodeAsCondition ifTrue: [ ^self builderForIfWithMessageNodeAsCondition: aMessageNode ].
	aMessageNode isAnd ifTrue: [ 
		condition := aMessageNode receiver.
		condition isNotNil ifTrue: [^self builderForNotNilCheck: aMessageNode ]].
	aMessageNode isOr ifTrue: [ 
		condition := aMessageNode receiver.
		condition isMessageNode ifTrue: [ condition isIsNil ifTrue: [^self builderForIsNilCheck: aMessageNode ]]].

	^NoTypeCastApplierBuilder new

]

{ #category : #'casting applier builder' }
MethodTypeCheckerVisitor >> newBuilderIfIsTypeCheck: condition in: aMessageNode [
	
	| incompleteTypeInfoReasons types implementors typesToCastTo typesToReject |

	condition isUnaryMessageSend ifFalse: [ ^NoTypeCastApplierBuilder new ].

	incompleteTypeInfoReasons := OrderedCollection new.
	types := blockCastingApplier receiverTypesFor: condition in: actualMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons.
	incompleteTypeInfoReasons notEmpty ifTrue: [ ^NoTypeCastApplierBuilder new ].
	
	"I have to converted to array because nil can not be added to sets - Hernan"
	implementors := types asArray collect: [ :aType | aType lookupSelector: condition selectorSymbol ].
	(implementors includes: nil) ifTrue: [ ^NoTypeCastApplierBuilder new ].
	implementors := implementors asIdentitySet.
	
	typesToCastTo := (implementors reject: [ :anImplementor | anImplementor isReturnSpecialFalse ]) collect: [ :anImplementor | anImplementor methodClass ].
	typesToReject := (implementors reject: [ :anImplementor | anImplementor isReturnSpecialTrue ]) collect: [ :anImplementor | anImplementor methodClass ].
		
	^IsKindOfManyTypeCastApplierBuilder 
		to: typesToCastTo 
		rejecting: typesToReject 
		on: condition receiver 
		during: aMessageNode arguments first
		rejectingDuring: (aMessageNode arguments at: 2 ifAbsent: [ BlockNode empty ]).
	
]

{ #category : #initialization }
MethodTypeCheckerVisitor >> prepareToValue [
	
	methodNode := methodReference methodNode.
	actualMethod := methodReference compiledMethod.
	
	blockCastingApplier := NoTypeCastApplier new.
	castingApplierBuilder := NoTypeCastApplierBuilder new.
]

{ #category : #visiting }
MethodTypeCheckerVisitor >> typeCheck: aMessageNode [
		
	self 
		withReceiverTypesOf: aMessageNode 
		do: [ :receiverTypes | self checkMessageSentIn: aMessageNode isImplementedInAll: receiverTypes ]
	
]

{ #category : #evaluating }
MethodTypeCheckerVisitor >> value [

	self 
		prepareToValue;
		visitMethodNode: methodNode.	

]

{ #category : #visiting }
MethodTypeCheckerVisitor >> visitArgumentsOf: aMessageNode [

	| currentCastingStrategyBuilder |
	
	currentCastingStrategyBuilder := castingApplierBuilder.
	castingApplierBuilder := self newBuilderFor: aMessageNode.
	
	aMessageNode argumentsInEvaluationOrder do: [:argument| argument accept: self].
	
	castingApplierBuilder addAfterMessageTypeCastsTo: blockCastingApplier.		
	castingApplierBuilder := currentCastingStrategyBuilder 

]

{ #category : #visiting }
MethodTypeCheckerVisitor >> visitBlockNode: aBlockNode [ 
	
	blockCastingApplier := castingApplierBuilder for: aBlockNode previous: blockCastingApplier.
	super visitBlockNode: aBlockNode.
	blockCastingApplier := blockCastingApplier previous.
	

]

{ #category : #visiting }
MethodTypeCheckerVisitor >> visitMessageNode: aMessageNode [ 

	aMessageNode receiver accept: self.
	aMessageNode selector accept: self.
	
	self 
		typeCheck: aMessageNode;
		visitArgumentsOf: aMessageNode.
		

]

{ #category : #visiting }
MethodTypeCheckerVisitor >> visitMessageNodeInCascade: aMessageNode [ 

	aMessageNode selector accept: self.
	
	self 
		typeCheck: aMessageNode;
		visitArgumentsOf: aMessageNode.
		
	
]

{ #category : #visiting }
MethodTypeCheckerVisitor >> withReceiverTypesOf: aMessageNode do: aTypesBlock [

	| incompleteTypeInfoReasons receiverTypes |
	
	incompleteTypeInfoReasons := OrderedCollection new.
	receiverTypes := blockCastingApplier receiverTypesFor: aMessageNode in: actualMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons.
	incompleteTypeInfoReasons do: [ :anIncompleteTypeInfoReason | anIncompleteTypeInfoReason addTo: self node: aMessageNode ].
	
	(receiverTypes isEmpty and: [ incompleteTypeInfoReasons isEmpty ])
		ifTrue: [ problems add: (TypeCheckingProblem forReceiverWithNoTypesOn: methodReference node: aMessageNode of: methodNode)]
		ifFalse: [ aTypesBlock value: receiverTypes ]
		
]
