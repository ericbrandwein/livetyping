Class {
	#name : #RemoveParameterWithActualScopeTest,
	#superclass : #Object,
	#category : #'LiveTyping-Tests'
}

{ #category : #'class factory' }
RemoveParameterWithActualScopeTest >> classOfOtherImplementorName [
	
	^#ClassOfSender
]

{ #category : #'class factory' }
RemoveParameterWithActualScopeTest >> classToRefactorName [

	^#ClassToRemoveParameter
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test01DoesNotChangePossibleMessageSendWhenInstructedToDoSo [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x | self m1: 1. false ifTrue: [ x m1: 1 ]'.
	classToRefactor new perform: senderToChange.
	
	refactor := RemoveParameterWithActualScope
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | self m1. false ifTrue: [ x m1: 1 ]'.
	
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test02CanNotRemoveParameterWithReceiverTypeOfMessageSendNotIncludedInImplementors [

	| classToRefactor oldSelector senderToChange classOfOtherImplementor messageSendWithInvalidReceiverTypes |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: 'm1: p1'.
	classOfOtherImplementor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1: 1'.
	classToRefactor new perform: senderToChange.
	
	self 
		should: [  
		 	RemoveParameterWithActualScope 
				named: 'p1' 
				from: classToRefactor>>oldSelector 
				implementors: { classToRefactor>>oldSelector }
				senders: { classToRefactor>>senderToChange }
				withPossibleMessageSends: false. ]
		raise: CanNotChangeSelectorWithNotIncludedTypes
		withExceptionDo: [ :anError |
			self assert: 1 equals: anError messageSendsWithInvalidReceiverTypes size.
			messageSendWithInvalidReceiverTypes := anError messageSendsWithInvalidReceiverTypes anyOne.
			self assert: classToRefactor>>senderToChange equals: messageSendWithInvalidReceiverTypes first.
			self assert: 'x' equals: messageSendWithInvalidReceiverTypes second receiver name.
			self assert: (messageSendWithInvalidReceiverTypes second selector isNamed: oldSelector).
			self assert: 1 equals: messageSendWithInvalidReceiverTypes third size.
			self assert: (messageSendWithInvalidReceiverTypes third includes: classOfOtherImplementor) ]
	
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test03RemovesParameterWhenReceiverTypeOfMessageSendIsSubtypeOfImplementorsType [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	self createClassNamed: self classOfOtherImplementorName subclassOf: classToRefactor.
	classToRefactor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x | x := ', self classOfOtherImplementorName, ' new. x m1: 1'.
	classToRefactor new perform: senderToChange.
	
	refactor := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.	
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | x := ', self classOfOtherImplementorName, ' new. x m1'.
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test04RemovesParameterWhenReceiverTypeOfMessageSendIsEqualToImplementorsTypes [

	| classToRefactor oldSelector senderToChange refactor classOfOtherImplementor |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: 'm1: p1'.
	classOfOtherImplementor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1: 1'.
	classToRefactor new perform: senderToChange.
	
	refactor := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.	

	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1'.
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test05RemovesParameterInDifferentMessageSendsWithReceiverTypeIsIncludedInImplementorsType [

	| classToRefactor oldSelector senderToChange refactor classOfOtherImplementor |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: 'm1: p1'.
	classOfOtherImplementor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x y | x := self. y := ', self classOfOtherImplementorName, ' new. x m1: 1. y m1: 1'.
	classToRefactor new perform: senderToChange.
	
	refactor := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x y | x := self. y := ', self classOfOtherImplementorName, ' new. x m1. y m1'
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test06RemovesParameterInDifferentMessageSendsWithReceiverTypeEqualToImplementorsType [

	| classToRefactor oldSelector senderToChange refactor classOfOtherImplementor |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: 'm1: p1'.
	classOfOtherImplementor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x y | x := y:= self. x := y := ', self classOfOtherImplementorName, ' new. x m1: 1. y m1: 1'.
	classToRefactor new perform: senderToChange.
	
	refactor := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x y | x := y:= self. x := y := ', self classOfOtherImplementorName, ' new. x m1. y m1'.
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test07RemovesParameterToPossibleMessageSendIfInstructedToDoSo [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x | self m1: 1. false ifTrue: [ x m1: 1]'.
	classToRefactor new perform: senderToChange.
	
	refactor := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: true.
		
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | self m1. false ifTrue: [ x m1]'.
	
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test08RemovesParameterWithReceiverTypeOfMessageSendNotIncludedInImplementorsButSelectorNotImplementedInTypeHierarchy [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor rename |
	
	oldSelector := #m1:.
	newSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classOfOtherImplementor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1: 1'.
	classToRefactor new perform: senderToChange.
	
	rename := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classOfOtherImplementor>>oldSelector 
		implementors: { classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.

	rename apply.

	self deny: (classToRefactor canUnderstand: newSelector).
	self assert: (classOfOtherImplementor canUnderstand: newSelector).
	self deny: (classOfOtherImplementor canUnderstand: oldSelector).
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1'.
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test09RemovesParameterOnlyToValidMessageSendWhenMoreSendsInSameMethod [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor rename |
	
	oldSelector := #m1:.
	newSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: 'm1: p1'.
	classOfOtherImplementor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' self m1: 1. ', self classOfOtherImplementorName, ' new m1: 1'.
	classToRefactor new perform: senderToChange.
	
	rename := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.

	rename apply.

	self assert: (classToRefactor canUnderstand: newSelector).
	self deny: (classToRefactor canUnderstand: oldSelector).
	self assert: (classOfOtherImplementor canUnderstand: oldSelector).
	self deny: (classOfOtherImplementor canUnderstand: newSelector).
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' self m1. ', self classOfOtherImplementorName, ' new m1: 1' .
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test10UsesTheModifiedSourceCodeWhenRemovingParameterToMethodWithSureAndPossibleSenders [

	| classToRefactor oldSelector senderToChange rename |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' |x| self m1: 1. x m1: 1'.
	
	rename :=RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange. }
		withPossibleMessageSends: false.

	rename apply.

	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' |x| self m1. x m1: 1'.
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test11CanNotRemoveParameterWithReceiverTypeOfCascadeMessageSendNotIncludedInImplementors [

	| classToRefactor oldSelector senderToChange classOfOtherImplementor messageSendWithInvalidReceiverTypes |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: 'm1: p1'.
	classOfOtherImplementor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1: 1; printString'.
	classToRefactor new perform: senderToChange.
	
	self 
		should: [  
		 	RemoveParameterWithActualScope 
				named: 'p1' 
				from: classToRefactor>>oldSelector 
				implementors: { classToRefactor>>oldSelector }
				senders: { classToRefactor>>senderToChange }
				withPossibleMessageSends: false. ]
		raise: CanNotChangeSelectorWithNotIncludedTypes
		withExceptionDo: [ :anError |
			self assert: 1 equals: anError messageSendsWithInvalidReceiverTypes size.
			messageSendWithInvalidReceiverTypes := anError messageSendsWithInvalidReceiverTypes anyOne.
			self assert: classToRefactor>>senderToChange equals: messageSendWithInvalidReceiverTypes first.
			self assert: 'x' equals: messageSendWithInvalidReceiverTypes second receiverOrCascadeReceiver name.
			self assert: (messageSendWithInvalidReceiverTypes second selector isNamed: oldSelector).
			self assert: 1 equals: messageSendWithInvalidReceiverTypes third size.
			self assert: (messageSendWithInvalidReceiverTypes third includes: classOfOtherImplementor) ]
	
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test12SuperclassInstanceCreationMessagesShouldNotBeUsed [

	| instanceCreationMethod |
	
	(RemoveParameter class organization listAtCategoryNamed: 'instance creation') do: [ :anInstanceCreationSelector |
		instanceCreationMethod := RemoveParameterWithActualScope class compiledMethodAt: anInstanceCreationSelector ifAbsent: [ self fail ].
		self assert: (instanceCreationMethod sendsSelector: #shouldNotImplement) ]
]

{ #category : #tests }
RemoveParameterWithActualScopeTest >> test13RemovesOtherThanLastParameterCorrectly [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1:m2:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	self createClassNamed: self classOfOtherImplementorName subclassOf: classToRefactor.
	classToRefactor compile: 'm1: p1 m2: p2'.
	classToRefactor compile: senderToChange, ' self m1: 1 m2: 2'.
	classToRefactor new perform: senderToChange.
	
	refactor := RemoveParameterWithActualScope 
		named: 'p1' 
		from: classToRefactor>>oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.	
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' self m2: 2'.
]
