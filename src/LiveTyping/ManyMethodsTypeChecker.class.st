Class {
	#name : #ManyMethodsTypeChecker,
	#superclass : #TypeChecker,
	#instVars : [
		'methodsToCheck',
		'typeCheckers'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
ManyMethodsTypeChecker class >> addMethodsOf: aClass to: methods [
 
	methods 
		addAll: aClass theNonMetaClass methodDictionary values;
		addAll: aClass theMetaClass methodDictionary values
]

{ #category : #'instance creation' }
ManyMethodsTypeChecker class >> forAll: aMethodToCheck [

	^self new initializeForAll: aMethodToCheck 
]

{ #category : #'instance creation' }
ManyMethodsTypeChecker class >> forAllClasses: classes [

	| methods |
	
	methods := OrderedCollection new.
	classes do: [ :aClass | self addMethodsOf: aClass to: methods ].
	
	^self forAll: methods
]

{ #category : #'instance creation' }
ManyMethodsTypeChecker class >> forClass: aClass [ 
	
	^self forAll: aClass theNonMetaClass methodDictionary values, aClass theMetaClass methodDictionary values
]

{ #category : #errors }
ManyMethodsTypeChecker >> errors [
	
	^typeCheckers 
		inject: OrderedCollection new
		into: [ :errors :typeChecker |
			errors addAll: typeChecker errors.
			errors ]
]

{ #category : #errors }
ManyMethodsTypeChecker >> errorsAndWarnings [
	
	| list |
	
	list := self sortedTypeCheckers
		inject: OrderedCollection new 
		into: [ :aList :aTypeChecker | 
			aList add: aTypeChecker methodReference.
			aList addAll: aTypeChecker errorsAndWarnings.
			aList ].
			
	^list
]

{ #category : #'problems to list' }
ManyMethodsTypeChecker >> errorsAndWarningsAsMethodReferencesWithProblems: showProblems [
	
	| list |
	
	list := OrderedCollection new.
	self sortedTypeCheckers do: [ :aTypeChecker | 
		(aTypeChecker hasErrorsOrWarnings or: [ showProblems and: [ aTypeChecker hasProblems ]])
			ifTrue: [
				list add: aTypeChecker method.
				list addAll: (aTypeChecker errorsAndWarningsAsMethodReferencesWithProblems: showProblems prefixing: '  ') ]].
				
	^list
]

{ #category : #'problems to list' }
ManyMethodsTypeChecker >> errorsAsMethodReferences [
	
	| list |
	
	list := OrderedCollection new.
	self sortedTypeCheckers do: [ :aTypeChecker | 
		aTypeChecker hasErrors ifTrue: [
			list add: aTypeChecker method.
			list addAll: (aTypeChecker errorsAsMethodReferencesPrefixing: '  ')
			"list addAll: aTypeChecker errorsAsMethodReferences"]].
			
	^list
]

{ #category : #errors }
ManyMethodsTypeChecker >> errorsDetect: aCondition ifNone: noneBlock [

	| errors |
	
	typeCheckers do: [ :typeChecker |
		errors := typeChecker errorsDetect: aCondition ifNone: [ nil ].
		errors ifNotNil: [ ^errors ]].
	
	^noneBlock value
]

{ #category : #errors }
ManyMethodsTypeChecker >> errorsIsEmpty [
	
	^typeCheckers allSatisfy: [ :aTypeChecker | aTypeChecker errorsIsEmpty ]
]

{ #category : #errors }
ManyMethodsTypeChecker >> errorsSize [
	
	^typeCheckers sum: [ :typeChecker | typeChecker errorsSize ] ifEmpty: [ 0 ]
]

{ #category : #testing }
ManyMethodsTypeChecker >> hasErrors [
	
	^typeCheckers anySatisfy: [ :aTypeChecker | aTypeChecker hasErrors ]
]

{ #category : #testing }
ManyMethodsTypeChecker >> hasErrorsOrWarnings [
	
	^typeCheckers anySatisfy: [ :aTypeChecker | aTypeChecker hasErrorsOrWarnings ]
]

{ #category : #testing }
ManyMethodsTypeChecker >> hasNoErrorsAndWarnings [
	
	^typeCheckers allSatisfy: [ :aTypeChecker | aTypeChecker hasNoErrorsAndWarnings ]
]

{ #category : #testing }
ManyMethodsTypeChecker >> hasProblems [
	
	^typeCheckers anySatisfy: [ :aTypeChecker | aTypeChecker hasProblems ]
]

{ #category : #initialization }
ManyMethodsTypeChecker >> initializeForAll: aMethodToCheck [ 

	methodsToCheck := aMethodToCheck collect: [ :aMethod | aMethod asMethodReference ]
]

{ #category : #method }
ManyMethodsTypeChecker >> methodSelector [
	
	^typeCheckers anyOne methodSelector 
]

{ #category : #problems }
ManyMethodsTypeChecker >> problems [

	^typeCheckers 
		inject: OrderedCollection new
		into: [ :problems :typeChecker |
			problems addAll: typeChecker problems.
			problems ]
]

{ #category : #problems }
ManyMethodsTypeChecker >> problemsDetect: aCondition ifNone: noneBlock [
	
	| problem |
	
	typeCheckers do: [ :typeChecker |
		problem := typeChecker problemsDetect: aCondition ifNone: [ nil ].
		problem ifNotNil: [ ^problem ]].
	
	^noneBlock value
]

{ #category : #problems }
ManyMethodsTypeChecker >> problemsSize [
	
	^typeCheckers sum: [ :aTypeChecker | aTypeChecker problemsSize ] ifEmpty: [ 0 ]
]

{ #category : #'problems to list' }
ManyMethodsTypeChecker >> sortedTypeCheckers [
	
	^typeCheckers sorted: [ :leftTypeChecker :rightTypeChecker | leftTypeChecker method <= rightTypeChecker method ]
]

{ #category : #'type checking' }
ManyMethodsTypeChecker >> value [
	
	typeCheckers := methodsToCheck collect: [:aMethod | aMethod typeCheck ].
	
	^self
]

{ #category : #warning }
ManyMethodsTypeChecker >> warnings [
	
	^typeCheckers 
		inject: OrderedCollection new
		into: [ :warnings :typeChecker |
			warnings addAll: typeChecker warnings.
			warnings ]
]

{ #category : #warning }
ManyMethodsTypeChecker >> warningsDetect: aCondition ifNone: noneBlock [

	| warning |
	
	typeCheckers do: [ :typeChecker |
		warning := typeChecker warningsDetect: aCondition ifNone: [ nil ].
		warning ifNotNil: [ ^warning ]].
	
	^noneBlock value
]

{ #category : #warning }
ManyMethodsTypeChecker >> warningsIsEmpty [
	
	^typeCheckers allSatisfy: [ :aTypeChecker | aTypeChecker warningsIsEmpty ]
]

{ #category : #warning }
ManyMethodsTypeChecker >> warningsSize [
	
	^typeCheckers sum: [ :typeChecker | typeChecker warningsSize ] ifEmpty: [ 0 ]
]
