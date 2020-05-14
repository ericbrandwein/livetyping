Class {
	#name : #ParseNodeTypesDisplay,
	#superclass : #Object,
	#instVars : [
		'parseNodeToAnalize',
		'methodNodeOwner',
		'definingClass',
		'methodToAnalyze',
		'types',
		'incompleteTypeInfoReasons',
		'typeInfo',
		'labels',
		'lines',
		'selectedIndex',
		'icons',
		'typesIndexLimit',
		'actions'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
ParseNodeTypesDisplay class >> of: aParseNodeToAnalize in: aMethodNodeOwner definedAt: aClass [

	^self new initliazeOf: aParseNodeToAnalize in: aMethodNodeOwner definedAt: aClass

]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> addCommonSupertypeLabel [

	typeInfo typesSize = 1
		ifTrue: [ | typeName |
			typeName := typeInfo types anyOne typeName.
			labels add: typeName.
			actions add: [ self browseClassNamed: typeName ].
			icons add: Theme current editFindReplaceIcon]
		ifFalse: [
			(typeInfo typesSize = 2 and: [ typeInfo includesNil ]) ifFalse: [
				typeInfo 
					withCommonSupertypeDo: [ :commonSupertype |
						labels add: commonSupertype typeName.
						actions add: [ self browseClassNamed: commonSupertype typeName ].
						icons add: Theme current goTopIcon ]
					ifGeneric: [ :genericType |
						labels add: self commonSelectorsOption.
						actions add: [ self showCommonSelectors ]. 
						icons add: Theme current spreadsheetIcon ].
				lines add: 1 ]]
		
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> addCrudOptions [

	(ParseNodeTypeInfo of: parseNodeToAnalize in: methodToAnalyze) 
		withTypeInfoDo: [ :parseNoteTypeInfo | self addCrudOptionsFor: parseNoteTypeInfo ]
		ifNone: []
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> addCrudOptionsFor: aTypeInfo [

	lines add: labels size.
	
	labels add: 'Add type ...'.
	icons add: Theme current listAddIcon.
	actions add: [ self addTypeTo: aTypeInfo ].
	
	labels add: 'Remove type ...'.
	icons add: Theme current listRemoveIcon.
	actions add: [ self removeTypeFrom: aTypeInfo ].
	
	labels add: 'Remove all types'.
	icons add: Theme current deleteIcon.
	actions add: [ self removeAllTypesFrom: aTypeInfo ].
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> addIncompleteTypesReasons [
	
	incompleteTypeInfoReasons notEmpty ifTrue: [
		lines add: labels size.
		incompleteTypeInfoReasons do: [ :aTypeInfoError | 
			labels add: aTypeInfoError reasonDescription.
			actions add: [ aTypeInfoError browse ].
			icons add: Theme current closeIcon ]]
	
	
	
]

{ #category : #crud }
ParseNodeTypesDisplay >> addTypeTo: aVariableTypeInfo [

	| className trimmedNamed |
	
	className := ClassNameRequestMorph request: 'Enter type to add' onCancel: [ ^self ].
	trimmedNamed := className withBlanksTrimmed.
	
	(Smalltalk classNamed: trimmedNamed) ifNotNil: [ :aType | 
		aVariableTypeInfo addType: aType ifFull: [ self inform: 'There is no more space to add type' ]]
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> addTypesLabels [

 	| typeIcon canBeNil |
	
	typeInfo typesSize > 1 ifTrue: [
		typeIcon := self typeIcon.
		canBeNil := false.
		typeInfo typesNames do: [ :aTypeName |
			aTypeName = UndefinedObject name 
				ifTrue: [ canBeNil := true ]
				ifFalse: [
					labels add: aTypeName.
					actions add: [ self browseClassNamed: aTypeName ].
					icons add: typeIcon ]].
		
		canBeNil ifTrue: [
			labels add: 'Can be nil'.
			icons add: Theme current warningIcon.
			actions add: []]].

]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> browseClassNamed: aName [

	(Smalltalk classNamed: aName)
		ifNil: [ self inform: 'Can not browse ', aName ]
		ifNotNil: [ :aClass | BrowserWindow fullOnClass: aClass selector: nil ]
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> browseIncompleteTypeInfo [

	^(incompleteTypeInfoReasons at: selectedIndex - typesIndexLimit) browse 
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> browseSelected [
	
	| action |
	
	action := actions at: selectedIndex ifAbsent: [ ^self ].
	action value
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> browseSelectedTypeOrCommonSelectors [

	| selected |
		
	selected := labels at: selectedIndex.
	selected = self commonSelectorsOption 
		ifTrue: [ self showCommonSelectors ]
		ifFalse: [ self browseClassNamed: selected ]
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> calculateLabelsAndLines [

	labels := OrderedCollection new.
	lines := OrderedCollection new.
	icons := OrderedCollection new.
	actions := OrderedCollection new.

	self 
		addCommonSupertypeLabel;
		addTypesLabels;
		addCrudOptions;
		addIncompleteTypesReasons

]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> calculateTypes [

	incompleteTypeInfoReasons := Set new.
	types := parseNodeToAnalize typesIn: methodToAnalyze addingIncompleteTypeInfoTo: incompleteTypeInfoReasons.
	incompleteTypeInfoReasons := incompleteTypeInfoReasons asArray 
	
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> commonSelectorsOption [

	^'Common selectors previous to Object'
]

{ #category : #accessing }
ParseNodeTypesDisplay >> definingClass [
	
	^definingClass
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> initializeTypeInfo [

	typeInfo := VariableTypeInfo new initializeRawTypes: types asArray.

]

{ #category : #initialization }
ParseNodeTypesDisplay >> initliazeOf: aParseNodeToAnalize in: aMethodNodeOwner definedAt: aClass [

	parseNodeToAnalize := aParseNodeToAnalize.
	methodNodeOwner := aMethodNodeOwner.
	definingClass := aClass.
	methodToAnalyze := definingClass 
		compiledMethodAt: methodNodeOwner selector 
		ifAbsent: [ NotImplementedMethod class: definingClass selector: methodNodeOwner selector ].
	

]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> isIncompleteTypeInfoSelection [
	
	^selectedIndex between: typesIndexLimit + 1 and: labels size
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> isTypeSelection [
	
	^selectedIndex between: 1 and: typesIndexLimit
]

{ #category : #accessing }
ParseNodeTypesDisplay >> parseNodeToAnalize [
	
	^parseNodeToAnalize
]

{ #category : #crud }
ParseNodeTypesDisplay >> removeAllTypesFrom: aVariableTypeInfo [
	
	aVariableTypeInfo removeAllTypes
]

{ #category : #crud }
ParseNodeTypesDisplay >> removeTypeFrom: aVariableTypeInfo [
	
	| typeNamesToRemove typeNamesToRemoveIcons selectedTypeToRemoveIndex typeNameToRemove options |
	
	typeNamesToRemove := aVariableTypeInfo typesNames.
	typeNamesToRemoveIcons := typeNamesToRemove collect: [ :aType | self typeIcon ].
	
	options := PopUpMenu labelArray: typeNamesToRemove lines: #() icons: typeNamesToRemoveIcons.
	selectedTypeToRemoveIndex := options startUpWithCaption: 'Select type to remove'.
	
	typeNameToRemove := typeNamesToRemove at: selectedTypeToRemoveIndex ifAbsent: [ ^self ].
	aVariableTypeInfo removeType: (Smalltalk classNamed: typeNameToRemove)
]

{ #category : #showing }
ParseNodeTypesDisplay >> show [

	self 
		calculateTypes;
		showTypes
		
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> showCommonSelectors [

	 | commonSelectors menu selectedSelectorIndex |
			
	commonSelectors := typeInfo commonSelectorsPreviousToObject.
	commonSelectors isEmpty ifTrue: [ ^self inform: 'There are no common selectors' ].
	commonSelectors := commonSelectors sorted.
	
	menu := PopUpMenu labelArray: commonSelectors.
	selectedSelectorIndex := menu startUpWithCaption: 'Common selectors'.
	selectedSelectorIndex = 0 ifFalse: [ Smalltalk browseAllActualImplementorsOf: (commonSelectors at: selectedSelectorIndex) forAll: typeInfo types ]
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> showTypes [

	types isEmpty 
		ifTrue: [ self inform: 'There is no type info for ', parseNodeToAnalize nodeTypeAndIdentifierPrintString ]
		ifFalse: [ self showTypesWhenNotEmpty ].
	
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> showTypesPopUp [

	| menu |

	menu := PopUpMenu labelArray: labels lines: lines icons: icons.
	selectedIndex := menu startUpWithCaption: 'Type info of ', parseNodeToAnalize nodeTypeAndIdentifierPrintString .

]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> showTypesWhenNotEmpty [

	self 
		initializeTypeInfo;
		calculateLabelsAndLines;
		showTypesPopUp;
		browseSelected	
]

{ #category : #'showing - private' }
ParseNodeTypesDisplay >> typeIcon [

	^Theme current editFindReplaceIcon
]

{ #category : #accessing }
ParseNodeTypesDisplay >> typeInfo [
	
	^typeInfo
]
