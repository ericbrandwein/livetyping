"
SUnit tests for AdditionalMethodState
"
Class {
	#name : #AdditionalMethodStateTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #'as yet unclassified' }
AdditionalMethodStateTest class >> acreateMethodVariableRawTypesFor: variableName in: method [

	(variableName = 'arg1' and: [ method selector = #m02_one_argument: ]) ifTrue: [ ^{ Integer } ].
	(variableName = 'arg1' and: [ method selector = #m03_one_temp_two_arguments:arg2: ]) ifTrue: [ ^{ SmallInteger } ].
	(variableName = 'arg2' and: [ method selector = #m03_one_temp_two_arguments:arg2: ]) ifTrue: [ ^{ LargeNegativeInteger } ].
	(variableName = 't1' and: [ method selector = #m03_one_temp_two_arguments:arg2: ]) ifTrue: [ ^{ LargePositiveInteger } ].
	
	
]

{ #category : #assertions }
AdditionalMethodStateTest >> assertRawTypesOf: aVariableName in: method includesOnly: aType [

	| types |
	
	types := (method properties rawTypesOf: aVariableName ifAbsent: [ self error: 'not found' ]) reject: [ :type | type isNil ].
	
	self assert: types size equals: 1.
	self assert: (types includes: aType).

]

{ #category : #'test data' }
AdditionalMethodStateTest >> initializeTypeInfoFor: aSelector [

	| methodUnderTest |

	methodUnderTest := self class >> aSelector.
	methodUnderTest initializeTypeInformation.
	
	^methodUnderTest
]

{ #category : #'test data' }
AdditionalMethodStateTest >> m01_no_arguments_no_temporaries [
]

{ #category : #'test data' }
AdditionalMethodStateTest >> m02_one_argument: arg1 [
]

{ #category : #'test data' }
AdditionalMethodStateTest >> m03_one_temp_two_arguments: arg1 arg2: arg2 [

	| t1 |
	
	t1 := 1.
	
	^t1
]

{ #category : #'test data' }
AdditionalMethodStateTest >> m04_two_temps_one_temp_in_remote_vector [

	| t1 t2 |
	
	t1 := 1.
	[ t2 := t1 +  1.0 ] value.
	
	^t2
]

{ #category : #'test data' }
AdditionalMethodStateTest >> m05_only_temp_in_remote_vector [

	| t1 |
	
	[ t1 := 10 ] value.
	
	^t1
]

{ #category : #running }
AdditionalMethodStateTest >> setUp [

	| pragma |
	super setUp.
	pragma := (Object compiledMethodAt: #at:) penultimateLiteral at: #primitive:.
	
	amState := AdditionalMethodState selector: #at: with: pragma copy.

]

{ #category : #tests }
AdditionalMethodStateTest >> test01topBlockTempsMapReturnsTheTempsMapOfTheMethod [

	| thisMethodNode topContextTempsMap topContextTempsMapKey |
	
	thisMethodNode := thisContext methodNode.
	
	topContextTempsMap := thisMethodNode topBlockTempsMap.
	topContextTempsMapKey := thisMethodNode blockExtentsToTempsMap keys detect: [ :anInterval | anInterval first = 0 ].
	
	self assert: topContextTempsMap equals: (thisMethodNode blockExtentsToTempsMap at: topContextTempsMapKey)
]

{ #category : #tests }
AdditionalMethodStateTest >> test02MethodWithNoParametersNoTemporariesAreInitializedCorrectly [

	| methodUnderTest methodState |
	
	methodUnderTest := self initializeTypeInfoFor: #m01_no_arguments_no_temporaries.
	self m01_no_arguments_no_temporaries.
	methodState := methodUnderTest properties.
	
	"This assertions are questionables becuase I'm testing implementation but
	I do it becuase I want to see if the AdditionalMethodState is initialzed correctly - Hernan"
	self assert: methodState variablesRawTypes isNil.
	self assert: methodState remoteVectorRawTypes isNil.
	
	self assert: (methodState rawTypesOf: 'var1' ifAbsent: [ 1 ]) equals: 1.
	
]

{ #category : #tests }
AdditionalMethodStateTest >> test03MethodWithOnlyOneArgumentAreInitializedCorrectly [

	| methodUnderTest |
	
	methodUnderTest := self initializeTypeInfoFor: #m02_one_argument:.
	self m02_one_argument: 1.
	
	self assertRawTypesOf: 'arg1' in: methodUnderTest includesOnly: 1 class.
]

{ #category : #tests }
AdditionalMethodStateTest >> test04rawTypesOfInvalidVariableNameEvaluatesIfAbsentBlock [

	| methodUnderTest |
	
	methodUnderTest := self initializeTypeInfoFor: #m02_one_argument:.
	self m02_one_argument: 1.
	
	self assert: (methodUnderTest properties rawTypesOf: 'x' ifAbsent: [ nil ]) isNil
]

{ #category : #tests }
AdditionalMethodStateTest >> test05MethodWithOnlyOneTempTwoArgumentsAreInitializedCorrectly [

	| methodUnderTest |
	
	methodUnderTest := self initializeTypeInfoFor: #m03_one_temp_two_arguments:arg2:.
	self m03_one_temp_two_arguments: 'hello' arg2: 1.0.
	
	self assertRawTypesOf: 'arg1' in: methodUnderTest includesOnly: 'hello' class.
	self assertRawTypesOf: 'arg2' in: methodUnderTest includesOnly: 1.0 class.
	self assertRawTypesOf: 't1' in: methodUnderTest includesOnly: 1 class.

	
]

{ #category : #tests }
AdditionalMethodStateTest >> test06MethodWithRemoveVectorVariablesAreInitializedCorrectly [

	| methodUnderTest tempInRemoteVectorName tempNotInRemoveVectorName |
	
	methodUnderTest := self initializeTypeInfoFor: #m04_two_temps_one_temp_in_remote_vector.
	self m04_two_temps_one_temp_in_remote_vector.
	tempNotInRemoveVectorName := 't1'.
	tempInRemoteVectorName := 't2'.
	
	self assertRawTypesOf: tempInRemoteVectorName in: methodUnderTest includesOnly: 1.0 class.
	self assertRawTypesOf: tempNotInRemoveVectorName in: methodUnderTest includesOnly: 1 class.

	self assert: methodUnderTest properties remoteVectorRawTypes size equals: 1.
	self assert: methodUnderTest properties variablesRawTypes size equals: 1.	
]

{ #category : #tests }
AdditionalMethodStateTest >> test07RemoteVectorRawTypesIsNilWhenMethodHasNoVariableInRemoteVector [

	| methodUnderTest |
	
	methodUnderTest := self initializeTypeInfoFor: #m02_one_argument:.
	
	self assert: methodUnderTest properties remoteVectorRawTypes isNil.
	self assert: methodUnderTest properties variableNameToRemoteVectorTypeIndex isNil.
]

{ #category : #tests }
AdditionalMethodStateTest >> test08VariableRawTypesIsNilWhenMethodHasNoVariableButHasInRemoteVector [

	| methodUnderTest |
	
	methodUnderTest := self initializeTypeInfoFor: #m05_only_temp_in_remote_vector.
	
	self assert: methodUnderTest properties variablesRawTypes isNil.
	self assert: methodUnderTest properties variableNameToTypeIndex isNil.
]

{ #category : #tests }
AdditionalMethodStateTest >> test09CanGetRawTypesWhenMethodHasNoVariableButHasInRemoteVector [

	| methodUnderTest |
	
	methodUnderTest := self initializeTypeInfoFor: #m05_only_temp_in_remote_vector.
	
	self assert: (methodUnderTest properties rawTypesOf: 't1' ifAbsent: [ nil ]) notNil
]

{ #category : #tests }
AdditionalMethodStateTest >> testAnalogousCodeTo [
	"create a fake traitSource association property"
	| state |
	state := AdditionalMethodState new: 1.
	state 
		basicAt: 1
		put: #traitSource -> TSortable.
		
	self 
		shouldnt: [ state analogousCodeTo: state ]
		raise: MessageNotUnderstood
]

{ #category : #tests }
AdditionalMethodStateTest >> testCopy [

	| copy |
	copy := amState copy.

	self deny: amState == copy.
	self assert: amState method == copy method.
	self assert: amState selector == copy selector.

	self assert: amState pragmas equals: copy pragmas.
	self assert: amState properties equals: copy properties.

	amState pragmas withIndexDo: [:el :index| self deny: el == (copy pragmas at: index)].
]
