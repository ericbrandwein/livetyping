Class {
	#name : #RenameSelectorWithActualScopeTest,
	#superclass : #Object,
	#category : #'LiveTyping-Tests'
}

{ #category : #'class factory' }
RenameSelectorWithActualScopeTest >> classOfOtherImplementorName [
	
	^#ClassOfSender
]

{ #category : #'class factory' }
RenameSelectorWithActualScopeTest >> classToRefactorName [

	^#ClassToRenameSelector
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test01DoesNotRenamesPossibleMessageSendWhenInstructedToDoSo [

	| classToRefactor oldSelector senderToChange newSelector refactor |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | self ', oldSelector, '. false ifTrue: [ x ', oldSelector, ' ]'.
	classToRefactor new perform: senderToChange.
	
	refactor := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | self ', newSelector, '. false ifTrue: [ x ', oldSelector, ' ]'.
	
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test02CanNotRenameWithReceiverTypeOfMessageSendNotIncludedInImplementors [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor messageSendWithInvalidReceiverTypes |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	self 
		should: [  
		 	RenameSelectorWithActualScope 
				from: oldSelector 
				to: newSelector 
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
RenameSelectorWithActualScopeTest >> test03RenamesWhenReceiverTypeOfMessageSendIsSubtypeOfImplementorsType [

	| classToRefactor oldSelector senderToChange newSelector refactor |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	self createClassNamed: self classOfOtherImplementorName subclassOf: classToRefactor.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
	
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | x := ', self classOfOtherImplementorName, ' new. x ', newSelector.
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test04RenamesWhenReceiverTypeOfMessageSendIsEqualToImplementorsTypes [

	| classToRefactor oldSelector senderToChange newSelector refactor classOfOtherImplementor |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', newSelector .
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test05RenamesDifferentMessageSendsWithReceiverTypeIsIncludedInImplementorsType [

	| classToRefactor oldSelector senderToChange newSelector refactor classOfOtherImplementor |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x y | x := self. y := ', self classOfOtherImplementorName, ' new. x ', oldSelector, '. y ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x y | x := self. y := ', self classOfOtherImplementorName, ' new. x ', newSelector, '. y ', newSelector.
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test06RenamesDifferentMessageSendsWithReceiverTypeEqualToImplementorsType [

	| classToRefactor oldSelector senderToChange newSelector refactor classOfOtherImplementor |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x y | x := y:= self. x := y := ', self classOfOtherImplementorName, ' new. x ', oldSelector, '. y ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	refactor := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classToRefactor>>oldSelector.   classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.
		
	refactor apply.
	
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x y | x := y:= self. x := y := ', self classOfOtherImplementorName, ' new. x ', newSelector, '. y ', newSelector.
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test07RenamePossibleMessageSendIfInstructedToDoSo [

	| classToRefactor oldSelector senderToChange newSelector refactor |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | self ', oldSelector, '. false ifTrue: [ x ', oldSelector, ' ]'.
	classToRefactor new perform: senderToChange.
	
	refactor := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: true.
		
	refactor apply.
	
	self assert: (classToRefactor>>senderToChange) sourceCode equals: senderToChange, ' | x | self ', newSelector, '. false ifTrue: [ x ', newSelector, ' ]'.
	
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test08RenamesWithReceiverTypeOfMessageSendNotIncludedInImplementorsButSelectorNotImplementedInTypeHierarchy [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor rename |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	rename := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classOfOtherImplementor>>oldSelector }
		senders: { classToRefactor>>senderToChange }
		withPossibleMessageSends: false.

	rename apply.

	self deny: (classToRefactor canUnderstand: newSelector).
	self assert: (classOfOtherImplementor canUnderstand: newSelector).
	self deny: (classOfOtherImplementor canUnderstand: oldSelector).
	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', newSelector.
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test09RenamesOnlyValidMessageSendWhenMoreSendsInSameMethod [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor rename |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' self ', oldSelector, '. ', self classOfOtherImplementorName, ' new ', oldSelector.
	classToRefactor new perform: senderToChange.
	
	rename := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
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
		equals: senderToChange, ' self ', newSelector, '. ', self classOfOtherImplementorName, ' new ', oldSelector.
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test10UsesTheModifiedSourceCodeWhenRenamingAMethodWithSureAndPossibleSenders [

	| classToRefactor oldSelector senderToChange newSelector rename |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classToRefactor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' |x| self ', oldSelector, '. x ', oldSelector.
	
	rename := RenameSelectorWithActualScope 
		from: oldSelector 
		to: newSelector 
		implementors: { classToRefactor>>oldSelector }
		senders: { classToRefactor>>senderToChange.  }
		withPossibleMessageSends: false.

	rename apply.

	self 
		assert: (classToRefactor>>senderToChange) sourceCode 
		equals: senderToChange, ' |x| self ', newSelector, '. x ', oldSelector.
]

{ #category : #tests }
RenameSelectorWithActualScopeTest >> test11CanNotRenameWithReceiverTypeOfCascadeMessageSendNotIncludedInImplementors [

	| classToRefactor oldSelector senderToChange newSelector classOfOtherImplementor messageSendWithInvalidReceiverTypes |
	
	oldSelector := #m1.
	newSelector := #m2.
	senderToChange := #m3.
	
	classToRefactor := self createClassNamed: self classToRefactorName.
	classOfOtherImplementor := self createClassNamed: self classOfOtherImplementorName.
	classToRefactor compile: oldSelector asString.
	classOfOtherImplementor compile: oldSelector asString.
	classToRefactor compile: senderToChange, ' | x | x := self. x := ', self classOfOtherImplementorName, ' new. x ', oldSelector, '; printString'.
	classToRefactor new perform: senderToChange.
	
	self 
		should: [  
		 	RenameSelectorWithActualScope 
				from: oldSelector 
				to: newSelector 
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
RenameSelectorWithActualScopeTest >> test12SuperclassInstanceCreationMessagesShouldNotBeUsed [

	| instanceCreationMethod |
	
	(ChangeSelectorKeepingParameters class organization listAtCategoryNamed: 'instance creation') do: [ :anInstanceCreationSelector |
		instanceCreationMethod := RenameSelectorWithActualScope class compiledMethodAt: anInstanceCreationSelector ifAbsent: [ self fail ].
		self assert: (instanceCreationMethod sendsSelector: #shouldNotImplement) ]
]
