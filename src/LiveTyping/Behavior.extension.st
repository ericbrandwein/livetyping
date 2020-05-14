Extension { #name : #Behavior }

{ #category : #'*LiveTyping' }
Behavior >> compiledMethodAt: aSelector ifPresent: aFoundBlock ifAbsent: anAbsentBlock [ 
	
	^self methodDict at: aSelector ifPresent: aFoundBlock ifAbsent: anAbsentBlock.
]

{ #category : #'*LiveTyping' }
Behavior class >> createHierarchyInstanceVariableTypeInfoOf: anInstVarName with: types [

	anInstVarName = 'superclass' ifTrue: [^LocalInstanceVariableTypeInfo of: anInstVarName in: self are: {Metaclass. UndefinedObject }].
	^super createHierarchyInstanceVariableTypeInfoOf: anInstVarName with: types

	
]

{ #category : #'*LiveTyping' }
Behavior class >> createLocalInstanceVariableTypeInfoOf: anInstVarName with: types [

	anInstVarName = 'superclass' ifTrue: [^LocalInstanceVariableTypeInfo of: anInstVarName in: self are: {Metaclass. UndefinedObject}].
	^super createLocalInstanceVariableTypeInfoOf: anInstVarName with: types

	
]

{ #category : #'*LiveTyping' }
Behavior class >> createMethodReturnRawTypesOf: aMethod [

	((aMethod selector = #new or: [ aMethod selector = #new: ]) 
		and: [ aMethod methodClass = Behavior ]) ifTrue: [ ^nil ].

	^super createMethodReturnRawTypesOf: aMethod

	
]

{ #category : #'*LiveTyping' }
Behavior class >> createMethodReturnTypeInfoOf: aMethod [

	(aMethod methodClass = Behavior and: [ #(new new: basicNew basicNew:) includes: aMethod selector ]) 
		ifTrue: [ ^ ReturnTypeInfo of: aMethod are: { InstanceType new } ].

	^super createMethodReturnTypeInfoOf: aMethod

	
]

{ #category : #'*LiveTyping' }
Behavior >> definesInstanceVariableNamedInHierarchy: anInstanceVariableName [

	^self allInstVarNames includes: anInstanceVariableName
]

{ #category : #'*LiveTyping' }
Behavior >> highestClassImplementing: aSelector ifNone: aNoneBlock [

	| highestImplementorClass |

	self withAllSuperclassesDo: [ :aBehavior | (aBehavior includesSelector: aSelector) ifTrue: [ highestImplementorClass := aBehavior ]].
	
	^ highestImplementorClass ifNil: aNoneBlock 
]

{ #category : #'*LiveTyping' }
Behavior >> indexOfInstanceVariable: anInstVarName ifAbsent: aBlock [

	^self allInstVarNames indexOf: anInstVarName ifAbsent: aBlock 
]

{ #category : #'*LiveTyping' }
Behavior >> initializeMethodsTypeInformation [

	self methodsDo: [ :aCompiledMethod | aCompiledMethod initializeTypeInformation ]
]

{ #category : #'*LiveTyping' }
Behavior >> isSubclassesEmpty [

	self subclassResponsibility 
]

{ #category : #'*LiveTyping' }
Behavior >> methodVariablesTypesOf: aMethod [

	^MethodVariablesTypes of: aMethod 
]

{ #category : #'*LiveTyping' }
Behavior >> typeCheck [
	
	^(ManyMethodsTypeChecker forClass: self) value
]

{ #category : #'*LiveTyping' }
Behavior >> typeName [

	"If the class whishes to be shown in a different way in the selectors documentation. 
	For example, DenotativeObject does not show it self as a metaclass but as a class - Hernan"
	
	^self name
]

{ #category : #'*LiveTyping' }
Behavior >> withAllSubclassesImplementing: aSelector addTo: implementors [

	self withAllSubclassesDo: [ :aBehavior | 
		(aBehavior includesSelector: aSelector) ifTrue: [ implementors add: (MethodReference class: aBehavior selector: aSelector) ]].

	^implementors
]
