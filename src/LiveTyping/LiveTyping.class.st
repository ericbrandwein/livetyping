Class {
	#name : #LiveTyping,
	#superclass : #Object,
	#category : #LiveTyping
}

{ #category : #'redefined methods source code' }
LiveTyping class >> addAndClassifySelectorOriginalSourceCode [

	^'addAndClassifySelector: selector withMethod: compiledMethod inProtocol: category notifying: requestor
	| priorMethodOrNil priorProtocolOrNil |
	priorMethodOrNil _ self compiledMethodAt: selector ifAbsent: nil.
	priorProtocolOrNil _ self whichCategoryIncludesSelector: selector.
	self addSelectorSilently: selector withMethod: compiledMethod.
	SystemChangeNotifier uniqueInstance doSilently: [self organization classify: selector under: category].
	priorMethodOrNil
		ifNil: [
			SystemChangeNotifier uniqueInstance 
				methodAdded: compiledMethod 
				selector: selector 
				inProtocol: category 
				class: self 
				requestor: requestor ]
		ifNotNil: [
			SystemChangeNotifier uniqueInstance 
				methodChangedFrom: priorMethodOrNil 
				to: compiledMethod 
				selector: selector 
				inClass: self 
				requestor: requestor.
			category = priorProtocolOrNil ifFalse: [
				SystemChangeNotifier uniqueInstance
					selectorRecategorized: selector
					from: priorProtocolOrNil
					to: category
					inClass: self ]]'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> addAndClassifySelectorSourceCode [

	^'addAndClassifySelector: selector withMethod: compiledMethod inProtocol: category notifying: requestor

	| priorMethodOrNil priorProtocolOrNil |

	priorMethodOrNil _ self compiledMethodAt: selector ifAbsent: nil.
	priorProtocolOrNil _ self whichCategoryIncludesSelector: selector.
	self addSelectorSilently: selector withMethod: compiledMethod.
	compiledMethod initializeTypeInformation.
	SystemChangeNotifier uniqueInstance doSilently: [self organization classify: selector under: category].

	priorMethodOrNil
		ifNil: [
			SystemChangeNotifier uniqueInstance 
				methodAdded: compiledMethod 
				selector: selector 
				inProtocol: category 
				class: self 
				requestor: requestor ]
		ifNotNil: [
			
			SystemChangeNotifier uniqueInstance 
				methodChangedFrom: priorMethodOrNil 
				to: compiledMethod 
				selector: selector 
				inClass: self 
				requestor: requestor.
			category = priorProtocolOrNil ifFalse: [
				SystemChangeNotifier uniqueInstance
					selectorRecategorized: selector
					from: priorProtocolOrNil
					to: category
					inClass: self ]]'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> addAndClassifySelectorStep1SourceCode [

	^'addAndClassifySelector: nodeOrSelector withMethod: compiledMethod inProtocol: category notifying: requestor

	| priorMethodOrNil priorProtocolOrNil selector |

	selector := nodeOrSelector isSymbol ifTrue: [nodeOrSelector ] ifFalse: [ nodeOrSelector selector ].
	priorMethodOrNil _ self compiledMethodAt: selector ifAbsent: nil.
	priorProtocolOrNil _ self whichCategoryIncludesSelector: selector.
	self addSelectorSilently: selector withMethod: compiledMethod.
	compiledMethod initializeTypeInformation.
	SystemChangeNotifier uniqueInstance doSilently: [self organization classify: selector under: category].

	priorMethodOrNil
		ifNil: [
			SystemChangeNotifier uniqueInstance 
				methodAdded: compiledMethod 
				selector: selector 
				inProtocol: category 
				class: self 
				requestor: requestor ]
		ifNotNil: [
			
			SystemChangeNotifier uniqueInstance 
				methodChangedFrom: priorMethodOrNil 
				to: compiledMethod 
				selector: selector 
				inClass: self 
				requestor: requestor.
			category = priorProtocolOrNil ifFalse: [
				SystemChangeNotifier uniqueInstance
					selectorRecategorized: selector
					from: priorProtocolOrNil
					to: category
					inClass: self ]]'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> addAndClassifySelectorStep2SourceCode [

	^'addAndClassifySelector: node withMethod: compiledMethod inProtocol: category notifying: requestor

	| priorMethodOrNil priorProtocolOrNil selector |

	selector := node selector.
	priorMethodOrNil _ self compiledMethodAt: selector ifAbsent: nil.
	priorProtocolOrNil _ self whichCategoryIncludesSelector: selector.
	self addSelectorSilently: selector withMethod: compiledMethod.

	"I pass the methodNode becuase the compiledMethod needs the temps mapping to initialize its var raw types.
	So to avoid parsing and generating the code again to get the temps mapping I pass the alredy created method node - Hernan" 
	compiledMethod initializeTypeInformationUsing: node.

	SystemChangeNotifier uniqueInstance doSilently: [self organization classify: selector under: category].

	priorMethodOrNil
		ifNil: [
			SystemChangeNotifier uniqueInstance 
				methodAdded: compiledMethod 
				selector: selector 
				inProtocol: category 
				class: self 
				requestor: requestor ]
		ifNotNil: [
			
			SystemChangeNotifier uniqueInstance 
				methodChangedFrom: priorMethodOrNil 
				to: compiledMethod 
				selector: selector 
				inClass: self 
				requestor: requestor.
			category = priorProtocolOrNil ifFalse: [
				SystemChangeNotifier uniqueInstance
					selectorRecategorized: selector
					from: priorProtocolOrNil
					to: category
					inClass: self ]]'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> blockReturnTopOriginalSourceCode [

	^'blockReturnTop
	"Simulate the interpreter''s action when a ReturnTopOfStackToCaller bytecode is 
	 encountered in the receiver.  This should only happen in a closure activation."
	self assert: closureOrNil isClosure.
	^self return: self pop from: self'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> blockReturnTopSourceCode [

	^'blockReturnTop
	
	"I do not want block returns to affect method return types that is why
	I send return:from: to super - Hernan"
	
	self assert: closureOrNil isClosure.
	^super return: self pop from: self'
]

{ #category : #'initialization-private' }
LiveTyping class >> checkRedefinedMethodsDidNotChange [

	self 
		checkTimeStampOf: ContextPart>>#popIntoTemporaryVariable: is: 'eem 6/15/2008 11:34';
		checkTimeStampOf: ContextPart>>#return:from: is: 'ajh 3/5/2004 03:44';
		checkTimeStampOf: ContextPart>>#storeIntoRemoteTemp:inVectorAt: is: 'eem 5/12/2009 13:05'
]

{ #category : #'initialization-private' }
LiveTyping class >> checkTimeStampOf: aMethod is: expectedTimeStamp [

	aMethod timeStamp = expectedTimeStamp ifFalse: [ self error: aMethod classAndSelector, ' has changed' ].
]

{ #category : #menues }
LiveTyping class >> classListMenuOptions [

	^ {
			{
				#itemGroup 	-> 		5.
				#itemOrder 		-> 		20.
				#label 			-> 		'type check (T)'.
				#selector 		-> 		#typeCheckClass.
				#object 			-> 		#model.
				#icon 			-> 		#acceptIcon
			} asDictionary.
			{
				#itemGroup 	-> 		5.
				#itemOrder 		-> 		30.
				#label 			-> 		'reset types'.
				#selector 		-> 		#resetClassType.
				#object 			-> 		#model.
				#icon 			-> 		#deleteIcon
			} asDictionary.
		}.
	
]

{ #category : #'initialization-private' }
LiveTyping class >> compile: aNewSourceCode in: aClass ifOriginalSourceCodeIs: anOriginalSourceCode [
	
	| newSourceCodeMethodNode originalSourceMethodNode |
	
	newSourceCodeMethodNode := aClass methodNodeFor: aNewSourceCode.
	originalSourceMethodNode := aClass methodNodeFor: anOriginalSourceCode.
	
	newSourceCodeMethodNode selector = originalSourceMethodNode selector ifFalse: [ self error: 'New source code selector is not equal to original source code selector' ].
	(aClass sourceCodeAt: originalSourceMethodNode selector) = anOriginalSourceCode ifFalse: [ self error: 'Current source code of ', aClass name, '>>', originalSourceMethodNode selector, ' is not equal to the expected one' ].
	
	aClass compile: aNewSourceCode 
]

{ #category : #'initialization-private' }
LiveTyping class >> compileAfterInstallMethods [.

	self 
		compile: self addAndClassifySelectorStep1SourceCode in: ClassDescription ifOriginalSourceCodeIs: self addAndClassifySelectorOriginalSourceCode;
		compile: self compileClassifiedWithStampNotifyingLogSourceSourceCode in: ClassDescription ifOriginalSourceCodeIs: self compileClassifiedWithStampNotifyingLogSourceOriginalSourceCode;
		compile: self addAndClassifySelectorStep2SourceCode in: ClassDescription ifOriginalSourceCodeIs: self addAndClassifySelectorStep1SourceCode;
		compile: self doneCompilingSourceCode in: ClassDescription ifOriginalSourceCodeIs: self doneCompilingOriginalSourceCode;
		compile: self unloadSourceCode in: Class ifOriginalSourceCodeIs: self unloadOriginalSourceCode;
		compile: self recompileFromSourceCode in: Behavior ifOriginalSourceCodeIs: self recompileFromOriginalSourceCode;
		compile: self messageListKeyFromSourceCode in: CodeWindow ifOriginalSourceCodeIs: self messageListKeyFromOriginalSourceCode;
		compile: self mouseMoveLocalPositionSourceCode in: InnerTextMorph ifOriginalSourceCodeIs: self mouseMoveLocalPositionOriginalSourceCode;
		compile: self setSenderReceiverMethodArgumentsSourceCode in: MethodContext 
			ifOriginalSourceCodeIs: self setSenderReceiverMethodArgumentsOriginalSourceCode;
		compile: self blockReturnTopSourceCode in: MethodContext ifOriginalSourceCodeIs: self blockReturnTopOriginalSourceCode 

]

{ #category : #'redefined methods source code' }
LiveTyping class >> compileClassifiedWithStampNotifyingLogSourceOriginalSourceCode [

	^'compile: text classified: category withStamp: changeStamp notifying: requestor logSource: logSource
	| methodAndNode |
	methodAndNode _ self basicCompile: text asString notifying: requestor 
							trailer: self defaultMethodTrailer ifFail: [^nil].
	logSource ifTrue: [
		self logMethodSource: text forMethodWithNode: methodAndNode 
			inCategory: category withStamp: changeStamp notifying: requestor.
	].
	self addAndClassifySelector: methodAndNode selector withMethod: methodAndNode 
		method inProtocol: category notifying: requestor.
	self theNonMetaClass noteCompilationOf: methodAndNode selector meta: self isMeta.
	^ methodAndNode selector'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> compileClassifiedWithStampNotifyingLogSourceSourceCode [

	^'compile: text classified: category withStamp: changeStamp notifying: requestor logSource: logSource
	| methodAndNode |
	methodAndNode _ self basicCompile: text asString notifying: requestor 
							trailer: self defaultMethodTrailer ifFail: [^nil].
	logSource ifTrue: [
		self logMethodSource: text forMethodWithNode: methodAndNode 
			inCategory: category withStamp: changeStamp notifying: requestor.
	].
	self addAndClassifySelector: methodAndNode node withMethod: methodAndNode 
		method inProtocol: category notifying: requestor.
	self theNonMetaClass noteCompilationOf: methodAndNode selector meta: self isMeta.
	^ methodAndNode selector'
]

{ #category : #'initialization-private' }
LiveTyping class >> defineInstVarNamed: anInstVarName in: aClass [

	(aClass definesInstanceVariableNamed: anInstVarName ) ifFalse: [ aClass addInstVarName: anInstVarName ]
]

{ #category : #'redefined methods source code' }
LiveTyping class >> doneCompilingOriginalSourceCode [

	^'doneCompiling
	"A ClassBuilder has finished the compilation of the receiver.
	This message is a notification for a class that needs to do some
	cleanup / reinitialization after it has been recompiled."'
	

]

{ #category : #'redefined methods source code' }
LiveTyping class >> doneCompilingSourceCode [

	^'doneCompiling
	"A ClassBuilder has finished the compilation of the receiver.
	This message is a notification for a class that needs to do some
	cleanup / reinitialization after it has been recompiled."
	
	self withAllSubclassesDo: [ :aClass | aClass initializeInstanceVariablesRawTypes ]'
	

]

{ #category : #initialization }
LiveTyping class >> initialize [

	"Utilities informUser: 'Initializing live typing' during: [ self initializeLiveTyping ]."
	
]

{ #category : #initialization }
LiveTyping class >> initializeLiveTyping [

	self initializeTypeInformation.
	
		"modifyClassDescriptionShape;
		modifyAdditionalMethodStateShape;
		checkRedefinedMethodsDidNotChange;
		compileAfterInstallMethods;
		initializeTypeInformation;
		setAnnotationInfoForLiveTyping;
		registerRefactoringAppliers"
]

{ #category : #'initialization-private' }
LiveTyping class >> initializeTypeInformation [

	InstanceVariablesTypes initializeForAllClassesWithAllInstances.    
	MethodVariablesTypes initializeForAllClasses.

]

{ #category : #'redefined methods source code' }
LiveTyping class >> messageListKeyFromOriginalSourceCode [

	^'messageListKey: aChar from: view
	"Respond to a Command key.  I am a model with a code pane, and I also
	have a listView that has a list of methods.  The view knows how to get
	the list and selection."

	| sel class |
	aChar == $D ifTrue: [^ model toggleDiffing].

	sel _ model selectedMessageName.
	aChar == $m ifTrue: [  "These next two put up a type in if no message selected"
		^ self useSelector: sel orGetSelectorAndSendQuery: #browseAllImplementorsOf: to: Smalltalk].
	aChar == $n ifTrue: [
		^ self useSelector: sel orGetSelectorAndSendQuery: #browseAllCallsOn: to: Smalltalk].

	"The following require a class selection"
	(class _ model selectedClassOrMetaClass) ifNil: [^ self ].
	aChar == $b ifTrue: [^ BrowserWindow fullOnClass: class selector: sel].
	aChar == $N ifTrue: [^ self browseClassRefs].
	aChar == $i ifTrue: [^ self methodHierarchy].
	aChar == $h ifTrue: [^ self browseHierarchy].
	aChar == $p ifTrue: [^ self browseFullProtocol].

	sel
		ifNotNil: [
			"The following require a method selection"
			aChar == $o ifTrue: [^ model fileOutMessage].
			aChar == $c ifTrue: [^ model copySelector].
			aChar == $v ifTrue: [^ self browseVersions].
			aChar == $C ifTrue: [^ model showHomeCategory].
			aChar == $O ifTrue: [^ self openSingleMessageBrowser].
			aChar == $x ifTrue: [^ model removeMessage].
			aChar == $t ifTrue: [^ model runMethodTest].
			aChar == $r ifTrue: [^ model debugMethodTest].
			aChar == $R ifTrue: [^ self renameSelector].
			aChar == $U ifTrue: [^ self addParameter ].
			aChar == $I ifTrue: [^ self removeParameter ]]
		ifNil: [
			aChar == $R ifTrue: [^ model renameClass]]'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> messageListKeyFromSourceCode [

	^'messageListKey: aChar from: view
	"Respond to a Command key.  I am a model with a code pane, and I also
	have a listView that has a list of methods.  The view knows how to get
	the list and selection."

	| sel class |
	aChar == $D ifTrue: [^ model toggleDiffing].

	sel _ model selectedMessageName.
	aChar == $m ifTrue: [  "These next two put up a type in if no message selected"
		^ self useSelector: sel orGetSelectorAndSendQuery: #browseAllImplementorsOf: to: Smalltalk].
	aChar == $n ifTrue: [
		^ self useSelector: sel orGetSelectorAndSendQuery: #browseAllCallsOn: to: Smalltalk].

	aChar == $M ifTrue: [ ^ self browseActualImplementorsOfSelectedMethod ].
	aChar == $B ifTrue: [ ^ self browseActualSendersOfSelectedMethod ].
	aChar == $T ifTrue: [ ^ self model typeCheckClass ].
	aChar == $X ifTrue: [ ^ self model removeMessageCheckingActualSenders ].

	"The following require a class selection"
	(class _ model selectedClassOrMetaClass) ifNil: [^ self ].
	aChar == $b ifTrue: [^ BrowserWindow fullOnClass: class selector: sel].
	aChar == $N ifTrue: [^ self browseClassRefs].
	aChar == $i ifTrue: [^ self methodHierarchy].
	aChar == $h ifTrue: [^ self browseHierarchy].
	aChar == $p ifTrue: [^ self browseFullProtocol].

	sel
		ifNotNil: [
			"The following require a method selection"
			aChar == $o ifTrue: [^ model fileOutMessage].
			aChar == $c ifTrue: [^ model copySelector].
			aChar == $v ifTrue: [^ self browseVersions].
			aChar == $C ifTrue: [^ model showHomeCategory].
			aChar == $O ifTrue: [^ self openSingleMessageBrowser].
			aChar == $x ifTrue: [^ model removeMessage].
			aChar == $t ifTrue: [^ model runMethodTest].
			aChar == $r ifTrue: [^ model debugMethodTest].
			aChar == $R ifTrue: [^ self renameSelector].
			aChar == $U ifTrue: [^ self addParameter ].
			aChar == $I ifTrue: [^ self removeParameter ]]
		ifNil: [
			aChar == $R ifTrue: [^ model renameClass]]'
]

{ #category : #menues }
LiveTyping class >> messageListMenuOptions [

	^{{
				#itemGroup 		-> 		5.
				#itemOrder 		-> 		20.
				#label 			-> 		'Type Check (T)'.
				#selector 		-> 		#typeCheckMethod.
				#object 			-> 		#model.
				#icon 			-> 		#acceptIcon
		} asDictionary.
		{
				#itemGroup 		-> 		5.
				#itemOrder 		-> 		30.
				#label 			-> 		'Reset types'.
				#selector 		-> 		#resetMethodTypes.
				#object 			-> 		#model.
				#icon 			-> 		#deleteIcon
		} asDictionary.
		{
				#itemGroup 		-> 		40.
				#itemOrder 		-> 		15.
				#label 			-> 		'actual senders of it (B)'.
				#selector 		-> 		#browseActualSendersOfSelectedMethod.
				#icon 			-> 		#mailForwardIcon
		} asDictionary.
		{
				#itemGroup 		-> 		40.
				#itemOrder 		-> 		25.
				#label 			-> 		'actual implementors of it (M)'.
				#selector 		-> 		#browseActualImplementorsOfSelectedMethod.
				#icon 			-> 		#developmentIcon
		} asDictionary.
		{
				#itemGroup 		-> 		60.
				#itemOrder 		-> 		15.
				#label 			-> 		'remove method checking actual senders (X)'.
				#object 			-> 		#model.
				#selector 		-> 		#removeMessageCheckingActualSenders.
				#icon 			-> 		#deleteIcon
		} asDictionary.			
		}

]

{ #category : #'initialization-private' }
LiveTyping class >> modifyAdditionalMethodStateShape [

	#('variablesRawTypes' 'returnRawTypes' 'remoteVectorRawTypes' 'variableNameToTypeIndex' 'variableNameToRemoteVectorTypeIndex') 
		do: [ :aVariableName | self defineInstVarNamed: aVariableName  in: AdditionalMethodState ]
]

{ #category : #'initialization-private' }
LiveTyping class >> modifyClassDescriptionShape [

	[[ self defineInstVarNamed: 'instanceVariablesRawTypes' in: ClassDescription ] 
		on: Warning do: [ :aWarning | aWarning resume ]]
		on: Error do: [ :anError | anError return: nil ]

]

{ #category : #'redefined methods source code' }
LiveTyping class >> mouseMoveLocalPositionOriginalSourceCode [

	^'mouseMove: aMouseMoveEvent localPosition: localEventPosition

	aMouseMoveEvent mouseButton1Pressed ifFalse: [
		^ self enterClickableRegion: aMouseMoveEvent localPosition: localEventPosition ].
	self handleInteraction: [
		editor mouseMove: aMouseMoveEvent localPosition: localEventPosition].
	owner scrollSelectionIntoView'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> mouseMoveLocalPositionSourceCode [

	^'mouseMove: aMouseMoveEvent localPosition: localEventPosition

	self shouldShowBalloonHelp ifTrue: [
		aMouseMoveEvent hand 
			removePendingBalloonFor: self;
			triggerBalloonFor: self after: self balloonHelpDelayTime ].
	
	aMouseMoveEvent mouseButton1Pressed ifFalse: [
		^ self enterClickableRegion: aMouseMoveEvent localPosition: localEventPosition ].
	self handleInteraction: [
		editor mouseMove: aMouseMoveEvent localPosition: localEventPosition].
	owner scrollSelectionIntoView'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> recompileFromOriginalSourceCode [

	^'recompile: selector from: oldClass
	"Compile the method associated with selector in the receiver''s method dictionary."
	"ar 7/10/1999: Use oldClass compiledMethodAt: not self compiledMethodAt:"
	| method trailer methodNode |
	method _ oldClass compiledMethodAt: selector.
	trailer _ method trailer.
	methodNode _ self compilerClass new
				compile: (oldClass sourceCodeAt: selector)
				in: self
				notifying: nil
				ifFail: [^ self].   "Assume OK after proceed from SyntaxError"
	selector == methodNode selector ifFalse: [self error: ''selector changed!''].
	self addSelectorSilently: selector withMethod: (methodNode generate: trailer).
'

]

{ #category : #'redefined methods source code' }
LiveTyping class >> recompileFromSourceCode [

	^'recompile: selector from: oldClass
	"Compile the method associated with selector in the receiver''s method dictionary."
	"ar 7/10/1999: Use oldClass compiledMethodAt: not self compiledMethodAt:"
	| method trailer methodNode newMethod |
	method _ oldClass compiledMethodAt: selector.
	trailer _ method trailer.
	methodNode _ self compilerClass new
				compile: (oldClass sourceCodeAt: selector)
				in: self
				notifying: nil
				ifFail: [^ self].   "Assume OK after proceed from SyntaxError"
	selector == methodNode selector ifFalse: [self error: ''selector changed!''].
	newMethod _ methodNode generate: trailer.
	self addSelectorSilently: selector withMethod: newMethod.
	newMethod copyTypeInformationFrom: method using: methodNode'
]

{ #category : #'initialization-private' }
LiveTyping class >> registerRefactoringAppliers [

	RefactoringApplier 
		registerRenameSelectorApplier: RenameSelectorWithActualScopeApplier;
		registerAddParameterApplier: AddParameterWithActualScopeApplier;
		registerRemoveParameterApplier: RemoveParameterWithActualScopeApplier
		
]

{ #category : #'initialization-private' }
LiveTyping class >> setAnnotationInfoForLiveTyping [

	^ Preferences parameters at: #MethodAnnotations put: #(timeStamp messageCategory packages changeSets)
]

{ #category : #'redefined methods source code' }
LiveTyping class >> setSenderReceiverMethodArgumentsOriginalSourceCode [

	^'setSender: s receiver: r method: m arguments: args 
	"Create the receiver''s initial state."

	sender := s.
	receiver := r.
	method := m.
	closureOrNil := nil.
	pc := method initialPC.
	self stackp: method numTemps.
	1 to: args size do: [:i | self at: i put: (args at: i)]'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> setSenderReceiverMethodArgumentsSourceCode [

	^'setSender: s receiver: r method: m arguments: args 
	"Create the receiver''s initial state."

	| parameterIndex |
	
	sender := s.
	receiver := r.
	method := m.
	closureOrNil := nil.
	pc := method initialPC.
	self stackp: method numTemps.
	parameterIndex := args size.
	1 to: args size do: [:i | 
		method annotateTemporaryTypeOf: (self at: i put: (args at: i)) at: parameterIndex.
		parameterIndex := parameterIndex - 1. ]'
]

{ #category : #menues }
LiveTyping class >> smalltalkEditorCmdShortcutsSpec [

	^#(
			#(		$P	#showSelectionTypeInfo:		'Prints type info of selection')
			#(		$B	#actualSendersOfIt:				'Actual senders of message under cursor')
			#(		$M	#actualImplementorsOfIt:			'Actual implementors of message under cursor')
			#(		$L  #actualLocalImplementorsOfIt:  'Actual Local implementros of message under cursor')
			#(		$T  #typeCheckMethod:  'Type check the selected method')
		)

]

{ #category : #menues }
LiveTyping class >> smalltalkEditorMenuOptions [

	^{
			{
				#itemGroup 		-> 		37.
				#itemOrder 		-> 		20.
				#label 			-> 		'Show type info (P)'.
				#selector 		-> 		#showSelectionTypeInfo.
				#icon 			-> 		#helpIcon
			} asDictionary.
			{
				#itemGroup 		-> 		37.
				#itemOrder 		-> 		30.
				#label 			-> 		'Actual Senders of it (B)'.
				#selector 		-> 		#actualSendersOfIt.
				#icon 			-> 		#mailForwardIcon
			} asDictionary.
			{
				#itemGroup 		-> 		37.
				#itemOrder 		-> 		40.
				#label 			-> 		'Actual Implementors of it (M)'.
				#selector 		-> 		#actualImplementorsOfIt.
				#icon 			-> 		#developmentIcon
			} asDictionary.
			{
				#itemGroup 		-> 		37.
				#itemOrder 		-> 		50.
				#label 			-> 		'Actual Local Implementors of it (L)'.
				#selector 		-> 		#actualLocalImplementorsOfIt.
				#icon 			-> 		#developmentIcon
			} asDictionary.
			{
				#itemGroup 		-> 		37.
				#itemOrder 		-> 		60.
				#label 			-> 		'Type Check (T)'.
				#selector 		-> 		#typeCheckMethod.
				#icon 			-> 		#acceptIcon
			} asDictionary.
			{
				#itemGroup 		-> 		37.
				#itemOrder 		-> 		70.
				#label 			-> 		'Reset types'.
				#selector 		-> 		#resetMethodTypes.
				#object 			-> 		#codeProvider.
				#icon 			-> 		#deleteIcon
			} asDictionary.

		}

]

{ #category : #menues }
LiveTyping class >> systemCategoryMenuOptions [

	^{
			{
				#itemGroup 		-> 		5.
				#itemOrder 		-> 		10.
				#label 			-> 		'Type Check'.
				#selector 		-> 		#typeCheckCategory.
				#object 			-> 		#model.
				#icon 			-> 		#acceptIcon
			} asDictionary.
			{
				#itemGroup 		-> 		5.
				#itemOrder 		-> 		20.
				#label 			-> 		'reset types'.
				#selector 		-> 		#resetCategoryTypes.
				#object 			-> 		#model.
				#icon 			-> 		#deleteIcon
			} asDictionary.
		}.
	
]

{ #category : #'redefined methods source code' }
LiveTyping class >> unloadOriginalSourceCode [

	^'unload
	"Sent when a the class is removed.  Does nothing, but may be overridden by (class-side) subclasses."
	""
'
]

{ #category : #'redefined methods source code' }
LiveTyping class >> unloadSourceCode [

	^'unload
	"Sent when a the class is removed.  Does nothing, but may be overridden by (class-side) subclasses."

	self unloadFromAllRawTypes'
]
