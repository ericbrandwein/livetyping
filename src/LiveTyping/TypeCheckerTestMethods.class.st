Class {
	#name : #TypeCheckerTestMethods,
	#superclass : #Object,
	#category : #'LiveTyping-TypeChecking-Tests'
}

{ #category : #'as yet unclassified' }
TypeCheckerTestMethods class >> classMethodWithTypeError [
	
	1 date
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> andWithoutMessageAsReceiver [

	| temp1 |
	
	temp1 := true.
	
	^temp1 and: [ temp1 ]
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> cascadeMessageSend [

	self
		odd;
		printString
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> cascadeMessageSendWithTypeCast [

	| temp1 |
	
	temp1 := nil.
	temp1 := 1.
	
	temp1
		printString;
		ifNotNil: [ temp1 + 1 ]
	
]

{ #category : #casting }
TypeCheckerTestMethods >> castWithBlockInRejectBlock [

	nil ifNotNil: [ :temp1 | [ temp1 mod: 5 ] value ]
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> comparingForNilWithIfTrueIfFalse [
	
	| temp1 |
	
	temp1 := 1.
	temp1 := nil.
	temp1 == nil ifTrue: [] ifFalse: [ temp1 + 1] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> comparingForNilWithIfTrueIfFalseWhenNilFiltersOtherTypes [
	
	| temp1 |
	
	temp1 := 1.
	temp1 := nil.
	temp1 == nil ifTrue: [ temp1 subclasses ] ifFalse: [ temp1 + 1] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> comparingForNilWithIfTrueIfFalseWhenNilKeepsUndefinedObject [
	
	| temp1 |
	
	temp1 := 1.
	temp1 == nil ifTrue: [ temp1 * 1 ] ifFalse: [ temp1 + 1] 
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> emptyMethod [

	
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> equalsNilIfFalse [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 = nil ifFalse: [ temp1 + 1 ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> equalsNilIfFalseIfTrue [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 = nil ifFalse: [ temp1 + 1 ] ifTrue: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> equalsNilIfTrue [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 = nil ifTrue: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> equalsNilIfTrueIfFalse [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 = nil ifTrue: [ temp1 subclasses ] ifFalse: [ temp1 + 1 ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> identicalToNilIfFalse [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 == nil ifFalse: [ temp1 + 1 ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> identicalToNilIfFalseIfTrue [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 == nil ifFalse: [ temp1 + 1 ] ifTrue: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> identicalToNilIfTrue [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 == nil ifTrue: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNilCheck [

	| temp1 |
	
	temp1 := 1.
	temp1 := nil.
	temp1 ifNil: [ temp1 subclasses ].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNilIfNotNil [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 ifNil: [ temp1 subclasses ] ifNotNil: [ temp1 + 1 ].

]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNilWithReturn [

	| temp1 |
	
	temp1 := nil.
	temp1 := 1.
	
	temp1 ifNil: [ ^self ].
	temp1 + 1
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNotNilCheck [

	| temp1 |
	
	temp1 := nil.
	temp1 := 1.
	
	temp1 ifNotNil: [ temp1 +1 ]
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNotNilCheckAccesingOtherObject [

	| temp1 temp2 |
	
	temp1 := nil.
	temp2 := nil.
	temp1 ifNotNil: [ temp2 +1 ].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNotNilCheckWithArgument [

	nil ifNotNil: [ :one |  one + 2 ].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNotNilIfNil [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 ifNotNil: [ temp1 + 1 ] ifNil: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNotNilWithMessageSend [

	(self returnParameter: 1) ifNotNil: [ (self returnParameter: 1) + 1 ]
	
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNotNilWithoutBlock [

	| temp1 |
	
	temp1 := nil.
	temp1 := 1.
	
	temp1 ifNotNil: temp1 + 1
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> ifNotNilifNotNil: value [

	"
	self new ifNotNilifNotNil: nil; ifNotNilifNotNil: self new
	"	
	
	self returnParameter2: nil.
	value ifNotNil: [ :w | (w returnParameter2: 1) ifNotNil: [ :c | c + 1 ]] 
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> ifTrueCascadeSend [

	^true
		ifTrue: [ 1 + 1 ];
		yourself

]

{ #category : #casting }
TypeCheckerTestMethods >> isKindOfKeepsSubtypes [

	| temp1  |
	
	temp1 := 1.
	temp1 := OrderedCollection new.
	temp1 := LinkedList new.
	
	(temp1 isKindOf: Collection) ifTrue: [ temp1 addLast:1 ].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> isNilCondition [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 isNil ifTrue: [ temp1 subclasses ] ifFalse: [ temp1 + 1 ].
	temp1 isNil ifFalse: [ temp1 + 1 ] ifTrue: [ temp1 subclasses ].
	temp1 isNil ifTrue: [ temp1 subclasses ].
	temp1 isNil ifFalse: [ temp1 + 1 ].

]

{ #category : #'nil check' }
TypeCheckerTestMethods >> isNilOr [

	| temp1 |
	
	temp1 := nil.
	temp1 := 1.
	
	^temp1 isNil or: [ temp1 odd ]
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> messageSendAsConditionOfIfTrueWithCascadeSend [

	^true not
		ifTrue: [ 1 + 1 ];
		yourself

]

{ #category : #'other methods' }
TypeCheckerTestMethods >> methodNotAnnotatingTypes [
	
	'something' size
]

{ #category : #'methods with errors' }
TypeCheckerTestMethods >> methodWithManyTypeErrors [

	1 date.
	'hello' factorial
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> methodWithNoReturnTypes [
	
	self methodWithNoReturnTypes printString
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> methodWithReceiverWithNoTypes [
	
	| temp1 |
	
	false ifTrue: [ 
		temp1 := 1.
		temp1 date ].
	
	
]

{ #category : #'methods with errors' }
TypeCheckerTestMethods >> methodWithTypeError [
	
	1 date
]

{ #category : #'methods with errors' }
TypeCheckerTestMethods >> methodWithTypeErrorWithManyNotImplemented [
	
	| temp1 |
	
	temp1 := 1.
	temp1 := 'hello'.
	false ifTrue: [ temp1 date ]
]

{ #category : #'methods with warnings' }
TypeCheckerTestMethods >> methodWithWarningForError [
	
	1 date first
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> methodWithoutTypeErrors [
	
	1 + 1
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nestedIfNilCheck [

	| temp1 temp2 |
	
	temp1 := 1.
	temp1 := nil.
	temp2 := 2.
	temp2 := nil.
	temp1 ifNil: [ 
		temp2 ifNil: [ 
			temp1 subclasses.
			temp2 subclasses ]].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nestedIfNilCheckErrorsWhenOutsideOfRightIfNil [

	| temp1 temp2 |
	
	temp1 := 1.
	temp1 := nil.
	temp2 := 2.
	temp2 := nil.
	temp1 ifNil: [ 
		temp2 ifNil: [ ].
		temp2 subclasses ].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nestedIfNotNilCheck [

	| temp1 temp2 |
	
	temp1 := nil.
	temp1 := 1.
	temp2 := nil.
	temp2 := 2.
	temp1 ifNotNil: [ 
		temp2 ifNotNil: [ 
			temp1 +1.
			temp2 + 1 ]].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nestedIfNotNilCheckErrorsWhenOutsideOfRightIfNotNil [

	| temp1 temp2 |
	
	temp1 := nil.
	temp1 := 1.
	temp2 := nil.
	temp2 := 2.
	temp1 ifNotNil: [ 
		temp2 ifNotNil: [ ].
		temp2 * 1 ].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nestedRejects [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 := 'hello'.
	
	temp1 ifNotNil: [ (temp1 isKindOf: SmallInteger) ifFalse: [ temp1 first ]].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nilEqualsToIfTrueIfFalseOrIfFalseIfTrue [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	nil = temp1 ifTrue: [ temp1 subclasses ] ifFalse: [ temp1 + 1 ].
	nil = temp1 ifFalse: [ temp1 + 1 ] ifTrue: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nilEqualsToIfTrueOrIfFalse [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	nil = temp1 ifTrue: [ temp1 subclasses ].
	nil = temp1 ifFalse: [ temp1 + 1 ]
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nilIdenticalTo [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	nil == temp1 ifTrue: [ temp1 subclasses ] ifFalse: [ temp1 + 1 ].
	nil == temp1 ifFalse: [ temp1 + 1 ]
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> nilNotEqualOrIdenticalIdenticalTo [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	nil ~~ temp1 ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 subclasses ].
	nil ~= temp1 ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 subclasses ].
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> notEqualToNil [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 ~= nil ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 subclasses ].
	temp1 ~= nil ifFalse: [ temp1 subclasses ] ifTrue: [ temp1 + 1 ].
	temp1 ~= nil ifTrue: [ temp1 + 1 ].
	temp1 ~= nil ifFalse: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> notIdenticalToNil [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 ~~ nil ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 subclasses ].
	temp1 ~~ nil ifFalse: [ temp1 subclasses ] ifTrue: [ temp1 + 1 ].
	temp1 ~~ nil ifTrue: [ temp1 + 1 ].
	temp1 ~~ nil ifFalse: [ temp1 subclasses ] 
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> notNilAnd [

	| temp1 |
	
	temp1 := nil.
	temp1 := 1.
	
	^temp1 notNil and: [ temp1 odd ]
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> notNilAndIfTrue [

	| temp1 temp2 |
	
	temp1 := nil.
	temp1 := 1.
	temp2 := nil.
	temp2 := 1.
	
	^(temp1 notNil and: [ temp2 notNil ]) ifTrue: [ temp1 odd. temp2 odd ]
]

{ #category : #'nil check' }
TypeCheckerTestMethods >> notNilCondition [

	| temp1  |
	
	temp1 := 1.
	temp1 := nil.
	temp1 notNil ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 subclasses ].
	temp1 notNil ifFalse: [ temp1 subclasses ] ifTrue: [ temp1 + 1 ].
	temp1 notNil ifTrue: [ temp1 + 1 ].
	temp1 notNil ifFalse: [ temp1 subclasses ]
]

{ #category : #casting }
TypeCheckerTestMethods >> orCheck [

	| temp1  |
	
	temp1 := 1.
	temp1 := 1/3.
	temp1 := Date today.
	
	(temp1 isInteger or: [ temp1 isFraction ]) ifTrue: [ temp1 odd ] ifFalse: [ temp1 year ].
		


]

{ #category : #'nil check' }
TypeCheckerTestMethods >> orWithoutMessageAsReceiver [

	| temp1 |
	
	temp1 := true.
	
	^temp1 or: [ temp1 ]
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> returnParameter2: anObject [

	^anObject 
]

{ #category : #'other methods' }
TypeCheckerTestMethods >> returnParameter: anObject [

	^anObject 
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCastToWithEqualOrIdenticalTo [

	| temp1  |
	
	temp1 := 'hello'.
	temp1 := 1.
	
	SmallInteger = temp1 class ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 first ].
	SmallInteger = temp1 class ifFalse: [ temp1 first ] ifTrue: [ temp1 + 1 ].
	SmallInteger = temp1 class ifTrue: [ temp1 + 1 ].
	SmallInteger = temp1 class ifFalse: [ temp1 first ].

	SmallInteger == temp1 class ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 first ].
	SmallInteger == temp1 class ifFalse: [ temp1 first ] ifTrue: [ temp1 + 1 ].
	SmallInteger == temp1 class ifTrue: [ temp1 + 1 ].
	SmallInteger == temp1 class ifFalse: [ temp1 first ].

]

{ #category : #casting }
TypeCheckerTestMethods >> typeCastToWithNotEqualOrNotIdenticalTo [

	| temp1  |
	
	temp1 := 'hello'.
	temp1 := 1.
	
	SmallInteger ~= temp1 class ifTrue: [ temp1 first ] ifFalse: [ temp1 + 1 ].
	SmallInteger ~= temp1 class ifFalse: [ temp1 + 1 ] ifTrue: [ temp1 first ].
	SmallInteger ~= temp1 class ifTrue: [ temp1 first ].
	SmallInteger ~= temp1 class ifFalse: [ temp1 + 1 ].

	SmallInteger ~~ temp1 class ifTrue: [ temp1 first ] ifFalse: [ temp1 + 1 ].
	SmallInteger ~~ temp1 class ifFalse: [ temp1 + 1 ] ifTrue: [ temp1 first ].
	SmallInteger ~~ temp1 class ifTrue: [ temp1 first ].
	SmallInteger ~~ temp1 class ifFalse: [ temp1 + 1 ].

]

{ #category : #casting }
TypeCheckerTestMethods >> typeCastUsingIsKindOf [

	| temp1  |
	
	temp1 := 'hello'.
	temp1 := 1.
	
	(temp1 isKindOf: SmallInteger) ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 first ].
	(temp1 isKindOf: SmallInteger) ifFalse: [ temp1 first ] ifTrue: [ temp1 + 1 ].
	(temp1 isKindOf: SmallInteger) ifTrue: [ temp1 + 1 ].
	(temp1 isKindOf: SmallInteger) ifFalse: [ temp1 first ].

	
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCastWithEqualOrIdenticalTo [

	| temp1  |
	
	temp1 := 'hello'.
	temp1 := 1.
	
	temp1 class = SmallInteger ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 first ].
	temp1 class = SmallInteger ifFalse: [ temp1 first ] ifTrue: [ temp1 + 1 ].
	temp1 class = SmallInteger ifTrue: [ temp1 + 1 ].
	temp1 class = SmallInteger ifFalse: [ temp1 first ].

	temp1 class == SmallInteger ifTrue: [ temp1 + 1 ] ifFalse: [ temp1 first ].
	temp1 class == SmallInteger ifFalse: [ temp1 first ] ifTrue: [ temp1 + 1 ].
	temp1 class == SmallInteger ifTrue: [ temp1 + 1 ].
	temp1 class == SmallInteger ifFalse: [ temp1 first ].

]

{ #category : #casting }
TypeCheckerTestMethods >> typeCastWithNotEqualOrNotIdenticalTo [

	| temp1  |
	
	temp1 := 'hello'.
	temp1 := 1.
	
	temp1 class ~= SmallInteger ifTrue: [ temp1 first ] ifFalse: [ temp1 + 1 ].
	temp1 class ~= SmallInteger ifFalse: [ temp1 + 1  ] ifTrue: [ temp1 first ].
	temp1 class ~= SmallInteger ifTrue: [ temp1 first ].
	temp1 class ~= SmallInteger ifFalse: [ temp1 + 1 ].

	temp1 class ~~ SmallInteger ifTrue: [ temp1 first ] ifFalse: [ temp1 + 1 ].
	temp1 class ~~ SmallInteger ifFalse: [ temp1 + 1  ] ifTrue: [ temp1 first ].
	temp1 class ~~ SmallInteger ifTrue: [ temp1 first ].
	temp1 class ~~ SmallInteger ifFalse: [ temp1 + 1 ].

]

{ #category : #casting }
TypeCheckerTestMethods >> typeCastWithReturnOnIfFalse [

	| temp1  |
	
	temp1 := 'hello'.
	temp1 := 1.
	
	SmallInteger = temp1 class ifFalse: [^self ].
	temp1 odd 
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCastWithReturnOnIfTrue [

	| temp1  |
	
	temp1 := 'hello'.
	temp1 := 1.
	
	SmallInteger = temp1 class ifTrue: [^self ].
	temp1 first 
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCheckMessage [

	| temp1  |
	
	temp1 := Morph new.
	temp1 := PluggableMorph new.
	
	temp1 hasModel ifTrue: [ temp1 model ].
	
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCheckMessageNestedInsideIfNotNil [

	| temp1  |
	
	temp1 := nil.
	temp1 := Morph new.
	temp1 := PluggableMorph new.
	
	temp1 ifNotNil: [ temp1 hasModel ifTrue: [ temp1 model ]]
	
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCheckMessageWithFalseInSubclass [

	| temp1  |
	
	temp1 := OrderedCollection new.
	temp1 := Color new.
	
	temp1 isCollection ifTrue: [ temp1 add: 1 ] ifFalse: [ temp1 alpha ]
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCheckMessageWithFalse_True_False_InSubclasses [

	| temp1  |
	
	temp1 := 1.
	temp1 := OrderedCollection new.
	temp1 := Color new.
	
	temp1 isCollection 
		ifTrue: [ temp1 add: 1 ] 
		ifFalse: [ temp1 isNumber 
			ifTrue: [ temp1 + 1 ]
			ifFalse: [ temp1 alpha ]]
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCheckMessageWithReturnOnIfFalse [

	| temp1  |
	
	temp1 := OrderedCollection new.
	temp1 := 1.
	
	temp1 isNumber ifFalse: [ ^self ].
	temp1 odd
]

{ #category : #casting }
TypeCheckerTestMethods >> typeCheckMessageWithReturnOnIfTrue [

	| temp1  |
	
	temp1 := OrderedCollection new.
	temp1 := Color new.
	
	temp1 isCollection ifTrue: [ ^self ].
	temp1 alpha
]
