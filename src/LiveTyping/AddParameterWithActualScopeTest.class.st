Class {
	#name : #AddParameterWithActualScopeTest,
	#superclass : #Object,
	#category : #'LiveTyping-Tests'
}

{ #category : #'class factory' }
AddParameterWithActualScopeTest >> classOfOtherImplementorName [
	
	^#ClassOfSender
]

{ #category : #'class factory' }
AddParameterWithActualScopeTest >> classToRefactorName [

	^#ClassToAddParameter
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test01DoesNotChangePossibleMessageSendWhenInstructedToDoSo [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | self ', oldSelector, '. false ifTrue: [ x ', oldSelector, ' ]'.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | self m1: 1. false ifTrue: [ x ', oldSelector, ' ]'.
	
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test01_01_DoesNotChangePossibleMessageSendWhenInstructedToDoSoWithKeywordMessages [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1:m3:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: 'm1: p1 m3: p3'.
	classToRefactor compile: senderToChange, ' | x | self m1: 1 m3: 3. false ifTrue: [ x m1: 1 m3: 3 ]'.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p2'
		at: 2 
		initializedWith: '2'
		using: #m2: 
		toKeywordSelector: oldSelector  
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | self m1: 1 m2: 2 m3: 3. false ifTrue: [ x m1: 1 m3: 3 ]'.
	
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test02CanNotAddParameterWithReceiverTypeOfMessageSendNotIncludedInImplementors [

	| classToRefactor oldSelector senderToChange classOfOtherImplementor messageSendWithInvalidReceiverTypes |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	self 
		should: [  
		 	AddParameterWithActualScope 
				named: 'p1' 
				initializedWith: '1' 
				toUnarySelector: oldSelector 
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
AddParameterWithActualScopeTest >> test02_01_CanNotAddParameterWithReceiverTypeOfMessageSendNotIncludedInImplementorsForKeywordMessage [

	| classToRefactor oldSelector senderToChange classOfOtherImplementor messageSendWithInvalidReceiverTypes |
	
	oldSelector := #m1:m3:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: 'm1: p1 m3: p3'.
	classOfOtherImplementor compile: 'm1: p1 m3: p3'.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1: 1 m3: 3'.
	classToRefactor new perform: senderToChange.
		
	self 
		should: [  
			AddParameterWithActualScope 
				named: 'p2'
				at: 2 
				initializedWith: '2'
				using: #m2: 
				toKeywordSelector: oldSelector  
				implementors: { classToRefactor>>oldSelector }
				senders: { classToRefactor>>senderToChange }
				withPossibleMessageSends: false ]
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
AddParameterWithActualScopeTest >> test03AddParameterWhenReceiverTypeOfMessageSendIsSubtypeOfImplementorsType [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	self createClassNamed: self classOfOtherImplementorName subclassOf: classToRefactor.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.	
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | x := ', self classOfOtherImplementorName, ' new. x m1: 1'.
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test04AddParameterWhenReceiverTypeOfMessageSendIsEqualToImplementorsTypes [

	| classToRefactor oldSelector senderToChange refactor classOfOtherImplementor |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector 
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.	

	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1: 1'.
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test05AddParameterInDifferentMessageSendsWithReceiverTypeIsIncludedInImplementorsType [

	| classToRefactor oldSelector senderToChange refactor classOfOtherImplementor |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x y | x := self. y := ', self classOfOtherImplementorName, ' new. x ', oldSelector, '. y ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector  
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x y | x := self. y := ', self classOfOtherImplementorName, ' new. x m1: 1. y m1: 1'
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test06AddParameterInDifferentMessageSendsWithReceiverTypeEqualToImplementorsType [

	| classToRefactor oldSelector senderToChange refactor classOfOtherImplementor |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x y | x := y:= self. x := y := ', self classOfOtherImplementorName, ' new. x ', oldSelector, '. y ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector  
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x y | x := y:= self. x := y := ', self classOfOtherImplementorName, ' new. x m1: 1. y m1: 1'.
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test07AddParameterToPossibleMessageSendIfInstructedToDoSo [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | self ', oldSelector, '. false ifTrue: [ x ', oldSelector, ' ]'.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: true.
		
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | self m1: 1. false ifTrue: [ x m1: 1 ]'.
	
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test08AddParameterWithReceiverTypeOfMessageSendNotIncludedInImplementorsButSelectorNotImplementedInTypeHierarchy [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor rename |
	
	oldSelector := #m1.
	newSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	rename := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector 
		implementors: { classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.

	rename apply.

	self deny: (classToRefactor canUnderstand: newSelector).
	self assert: (classOfOtherImplementor canUnderstand: newSelector).
	self deny: (classOfOtherImplementor canUnderstand: oldSelector).
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x m1: 1'.
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test09AddParameterOnlyToValidMessageSendWhenMoreSendsInSameMethod [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor rename |
	
	oldSelector := #m1.
	newSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' self ', oldSelector, '. ', self classOfOtherImplementorName, ' new ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	rename := AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector 
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
		equals: senderToChange, ' self m1: 1. ', self classOfOtherImplementorName, ' new ', oldSelector .
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test10UsesTheModifiedSourceCodeWhenAddingParameterToMethodWithSureAndPossibleSenders [

	| classToRefactor oldSelector senderToChange rename |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' |x| self ', oldSelector, '. x ', oldSelector.
	
	rename :=AddParameterWithActualScope 
		named: 'p1' 
		initializedWith: '1' 
		toUnarySelector: oldSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange. }
		withPossibleMessageSends: false.

	rename apply.

	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' |x| self m1: 1. x ', oldSelector.
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test11CanNotAddParameterWithReceiverTypeOfCascadeMessageSendNotIncludedInImplementors [

	| classToRefactor oldSelector senderToChange classOfOtherImplementor messageSendWithInvalidReceiverTypes |
	
	oldSelector := #m1.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector, '; printString'.
	classToRefactor new perform: senderToChange.
	
	self 
		should: [  
		 	AddParameterWithActualScope 
				named: 'p1' 
				initializedWith: '1' 
				toUnarySelector: oldSelector 
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
AddParameterWithActualScopeTest >> test12SuperclassInstanceCreationMessagesShouldNotBeUsed [

	| instanceCreationMethod |
	
	(AddParameter class organization listAtCategoryNamed: 'instance creation') do: [ :anInstanceCreationSelector |
		instanceCreationMethod := AddParameterWithActualScope class compiledMethodAt: anInstanceCreationSelector ifAbsent: [ self fail ].
		self assert: (instanceCreationMethod sendsSelector: #shouldNotImplement) ]
]

{ #category : #tests }
AddParameterWithActualScopeTest >> test13AddLastParameterCorrectly [

	| classToRefactor oldSelector senderToChange refactor |
	
	oldSelector := #m1:.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	self createClassNamed: self classOfOtherImplementorName subclassOf: classToRefactor.
	classToRefactor compile: 'm1: p1'.
	classToRefactor compile: senderToChange, ' self m1: 1'.
	classToRefactor new perform: senderToChange.
	
	refactor := AddParameterWithActualScope 
		named: 'p2' 
		initializedWith: '2' 
		using: #m2: 
		toKeywordSelector: oldSelector  
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.	
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' self m1: 1 m2: 2'.
]
