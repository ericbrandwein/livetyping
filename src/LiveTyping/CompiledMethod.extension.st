Extension { #name : #CompiledMethod }

{ #category : #'*LiveTyping' }
CompiledMethod >> actualSendersOf: aCompiledMethod [ 
	
	^self actualSendersOf: aCompiledMethod using: self methodNode
	
]

{ #category : #'*LiveTyping' }
CompiledMethod >> actualSendersOf: aCompiledMethod using: aCompiledMethodMethodNode [
	
	| sendersCollector |
	
	sendersCollector := ActualMessageSendsCollector in: self of: aCompiledMethod.
	aCompiledMethodMethodNode accept: sendersCollector.
	
	^sendersCollector 
]

{ #category : #'*LiveTyping' }
CompiledMethod >> allRawTypesUnload: aClassToUnload [ 
	
	self withPropertiesDo: [ :properties | properties allRawTypesUnload: aClassToUnload ]
	
]

{ #category : #'*LiveTyping' }
CompiledMethod >> annotateRemoteTemporaryTypeOf: aValue at: anIndex [ 

	"See keepTemporaryTypeInfoAt:of: - Hernan"

	self 
		withPropertiesDo: [ :properties | properties annotateRemoteTemporaryTypeOf: aValue at: anIndex ]
		ifSelector: [ :selector | ]
]

{ #category : #'*LiveTyping' }
CompiledMethod >> annotateReturnTypeOf: aValue [

	"See keepTemporaryTypeInfoAt:of: - Hernan"

	self 
		withPropertiesDo: [ :properties | properties annotateReturnTypeOf: aValue ]
		ifSelector: [ :selector | ]
]

{ #category : #'*LiveTyping' }
CompiledMethod >> annotateTemporaryTypeOf: aValue at: aTemporaryIndex [ 

	"Used on code simulation. 
	It bypasses MethodVariables and MethodVariableTypes for performance reason.
	If the method is not keeping type info or the index is invalid or the types array is full, it does nothing
	because we do not want to get error while debugging - Hernan"
	
	self 
		withPropertiesDo: [ :properties | properties annotateTemporaryTypeOf: aValue at: aTemporaryIndex ]
		ifSelector: [ :selector | ]
		
]

{ #category : #'*LiveTyping' }
CompiledMethod >> asMethodReference [
	
	^MethodReference method: self
]

{ #category : #'*LiveTyping' }
CompiledMethod >> caretAutoCompleterDocumentation [

	^ Text string: String newLineString, '^ ' attributes: (SHTextStylerST80 attributesFor: #return)
]

{ #category : #'*LiveTyping' }
CompiledMethod >> classAndSelector [

	^String streamContents: [:stream | self printClassAndSelectorOn: stream ]
]

{ #category : #'*LiveTyping' }
CompiledMethod >> compiledMethod [

	"To be polimorphic with MethodReference - Hernan"
	^self
]

{ #category : #'*LiveTyping' }
CompiledMethod >> copyTypeInformationFrom: aMethodForSameSelectorAndClass using: aMethodNode [

	| properties |
	
	self selector = aMethodForSameSelectorAndClass selector ifFalse: [ self error: 'Should not copy type information from a method with different selector' ].
	self methodClass name = aMethodForSameSelectorAndClass methodClass name ifFalse: [  self error: 'Should not copy type information of a method from different class' ].
	
	properties := self properties.
	"I have to set it because #properties creates a new AdditionaMethodState but does not set it - Hernan"
	self penultimateLiteral: properties.
	aMethodForSameSelectorAndClass 
		withPropertiesDo: [ :otherMethodProperties | properties copyTypeInformationFrom: otherMethodProperties ]
		ifSelector: [ :selector | properties initializeTypeInformationUsing: aMethodNode ]
]

{ #category : #'*LiveTyping' }
CompiledMethod >> doesOnlySurelySend: aCompiledMethod [ 
	
	| actualMessageSendsCollector |
	
	actualMessageSendsCollector := self actualSendersOf: aCompiledMethod.
	
	^actualMessageSendsCollector hasOnlySureMessageSends
]

{ #category : #'*LiveTyping' }
CompiledMethod >> initializeTypeInformation [
	
	self initializeTypeInformationUsing: self methodNode
]

{ #category : #'*LiveTyping' }
CompiledMethod >> initializeTypeInformationUsing: aMethodNode [
	
	| properties |
	
	properties := self properties.
	"I have to set it because #properties creates a new AdditionaMethodState but does not set it - Hernan"
	self penultimateLiteral: properties.
	properties initializeTypeInformationUsing: aMethodNode 
]

{ #category : #'*LiveTyping' }
CompiledMethod >> isAbstract [
	
	^self sendsSelector: #subclassResponsibility
]

{ #category : #'*LiveTyping' }
CompiledMethod >> isAnnotatingTypes [
	
	^self withPropertiesDo: [ :properties | true ] ifSelector: [ :selector | false ] 
]

{ #category : #'*LiveTyping' }
CompiledMethod >> isPrimitive [
	
	^ self primitive ~= 0
]

{ #category : #'*LiveTyping' }
CompiledMethod >> isQuickReturnSelf [
	
	^self primitive = 256
]

{ #category : #'*LiveTyping' }
CompiledMethod >> isReturnSpecialFalse [
	
	^self primitive = 258
]

{ #category : #'*LiveTyping' }
CompiledMethod >> isReturnSpecialTrue [
	
	^self primitive = 257
]

{ #category : #'*LiveTyping' }
CompiledMethod >> isValid [

	"To be polimorphic with MethodReference - Hernan"
	^true
]

{ #category : #'*LiveTyping' }
CompiledMethod >> liveTypingAutoCompleterDocumentation [
	
	| parametersTypeInfo |
 
	parametersTypeInfo := self methodVariablesTypes. 

	^ self 
		autoCompleterDocumentationAppendingToParameter: [ :aParameterName | 
			self parameterTypeAutoCompleterDocumentationOf: aParameterName using: parametersTypeInfo ]
		toReturn: [
			self caretAutoCompleterDocumentation append: self returnTypeAutoCompleterDocumentation ].

]

{ #category : #'*LiveTyping' }
CompiledMethod >> methodVariablesTypes [

	^self methodClass methodVariablesTypesOf: self
]

{ #category : #'*LiveTyping' }
CompiledMethod >> parameterTypeAutoCompleterDocumentationOf: aParameterName using: parametersTypeInfo [

	^ Text 
		string: (parametersTypeInfo printReducedTypesOf: aParameterName ifAbsent: [ '<?>' ]) 
		attributes: (SHTextStylerST80 attributesFor: #tempVar)
]

{ #category : #'*LiveTyping' }
CompiledMethod >> printClassAndSelectorOn: aStream [

	aStream
		print: self methodClass;
		nextPutAll: '>>';
		nextPutAll: self selector storeString
]

{ #category : #'*LiveTyping' }
CompiledMethod >> printTypeInfoOn: aStream [

	| variablesTypes beforeVariablesTypesPosition |
	
	variablesTypes := self methodVariablesTypes.
	beforeVariablesTypesPosition := aStream position.
	
	variablesTypes printVariablesTypesOn: aStream.
	beforeVariablesTypesPosition = aStream position 
		ifTrue: [ variablesTypes printTypesInfoHeaderOn: aStream ]
		ifFalse: [ aStream position: aStream position - 1].
	
	self returnTypeInfo printOn: aStream.
	aStream newLine.
	variablesTypes printTypesInfoFooterOn: aStream
]

{ #category : #'*LiveTyping' }
CompiledMethod >> returnRawTypes [
	
	^self typeAnnotationsHolder returnRawTypes
	
]

{ #category : #'*LiveTyping' }
CompiledMethod >> returnTypeAutoCompleterDocumentation [

	^ Text 
		string: self returnTypeInfo printReducedTypes 
		attributes: (SHTextStylerST80 attributesFor: #tempVar)

]

{ #category : #'*LiveTyping' }
CompiledMethod >> returnTypeInfo [

	^ self methodClass createMethodReturnTypeInfoOf: self 
]

{ #category : #'*LiveTyping' }
CompiledMethod >> returnTypes [
	
	^self returnTypeInfo types
]

{ #category : #'*LiveTyping' }
CompiledMethod >> sureMessageSendsRangesOf: aSentSelector whenSendTo: aReceiverTypes [

	| methodNode collector implementor ranges |
	
	methodNode := self methodNode.
	ranges := Set new.
		
	aReceiverTypes do: [ :aReceiverType |
		implementor := aReceiverType lookupSelector: aSentSelector.
		implementor ifNotNil: [ 
			collector := ActualMessageSendsCollector in: self of: implementor.
			methodNode accept: collector. 
			collector sureMessageSends do: [ :aMessageSend | ranges add: (
				methodNode rangeForNode: aMessageSend ifAbsent: [self error: 'Should not happen'])]]].
	
	^ranges 
]

{ #category : #'*LiveTyping' }
CompiledMethod >> typeAnnotationsHolder [
	
	^self 
		withPropertiesDo: [ :properties | properties ] 
		ifSelector: [ :aSelector | MethodNotAnnotatingTypes signalFor: self ].


]

{ #category : #'*LiveTyping' }
CompiledMethod >> typeCheck [
	
	^(MethodTypeChecker for: self) value
]

{ #category : #'*LiveTyping' }
CompiledMethod >> typeInfoOfVariableNamed: aVarName [ 

	^self methodVariablesTypes typeInfoOf: aVarName
]

{ #category : #'*LiveTyping' }
CompiledMethod >> typeInfoOfVariableNamed: aVarName ifAbsent: aBlock [

	^self methodVariablesTypes typeInfoOf: aVarName ifAbsent: aBlock
]

{ #category : #'*LiveTyping' }
CompiledMethod >> typesOfInstanceVariableNamed: anInstVarName [

	^self methodClass typesOfInstanceVariableNamed: anInstVarName 
]

{ #category : #'*LiveTyping' }
CompiledMethod >> typesOfInstanceVariableNamed: anInstVarName ifAbsent: aBlock [

	^self methodClass typesOfInstanceVariableNamed: anInstVarName ifAbsent: aBlock
]

{ #category : #'*LiveTyping' }
CompiledMethod >> typesOfVariableNamed: aVarName [

	^self methodVariablesTypes typesOf: aVarName
]

{ #category : #'*LiveTyping' }
CompiledMethod >> typesOfVariableNamed: aVarName ifAbsent: aBlock [

	^self methodVariablesTypes typesOf: aVarName ifAbsent: aBlock
]

{ #category : #'*LiveTyping' }
CompiledMethod >> variablesRawTypes [
	
	^self typeAnnotationsHolder variablesRawTypes
]
