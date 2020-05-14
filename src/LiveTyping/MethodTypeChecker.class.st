Class {
	#name : #MethodTypeChecker,
	#superclass : #TypeChecker,
	#instVars : [
		'method',
		'errors',
		'warnings',
		'problems'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
MethodTypeChecker class >> for: aMethod [ 
	
	^self new initializeFor: aMethod 
]

{ #category : #'problems to list' }
MethodTypeChecker >> addMethodReferencesOf: aTypeCheckingProblemCollection prefixing: aPrefix to: methodReferencesCollection [

	aTypeCheckingProblemCollection do: [ :aTypeCheckingProblem |
		methodReferencesCollection add: (TypeCheckingProblemToMethodReferenceAdapter of: aTypeCheckingProblem prefixing: aPrefix) ].
	
	^methodReferencesCollection 
]

{ #category : #method }
MethodTypeChecker >> classAndSelector [
	
	^method classAndSelector 
]

{ #category : #errors }
MethodTypeChecker >> errors [
	
	^errors
]

{ #category : #errors }
MethodTypeChecker >> errorsAndWarnings [

	^errors, warnings
	
]

{ #category : #'problems to list' }
MethodTypeChecker >> errorsAndWarningsAsMethodReferencesWithProblems: showProblems [
	
	^self errorsAndWarningsAsMethodReferencesWithProblems: showProblems prefixing: ''
]

{ #category : #'problems to list' }
MethodTypeChecker >> errorsAndWarningsAsMethodReferencesWithProblems: showingProblems prefixing: aPrefix [
	
	| listToShow |
	
	listToShow := self addMethodReferencesOf: errors prefixing: aPrefix to: OrderedCollection new.
	self addMethodReferencesOf: warnings prefixing: aPrefix to: listToShow.
	showingProblems ifTrue: [ self addMethodReferencesOf: problems prefixing: aPrefix to: listToShow ].
	
	^listToShow
]

{ #category : #'problems to list' }
MethodTypeChecker >> errorsAsMethodReferences [
	
	^self errorsAsMethodReferencesPrefixing: ''
]

{ #category : #'problems to list' }
MethodTypeChecker >> errorsAsMethodReferencesPrefixing: aPrefix [

	^self addMethodReferencesOf: errors prefixing: aPrefix to: OrderedCollection new
]

{ #category : #errors }
MethodTypeChecker >> errorsDetect: aCondition ifNone: aNoneBlock [

	^errors detect: aCondition ifNone: aNoneBlock 
]

{ #category : #errors }
MethodTypeChecker >> errorsIsEmpty [
	
	^errors isEmpty 
]

{ #category : #errors }
MethodTypeChecker >> errorsSize [
	
	^errors size
]

{ #category : #testing }
MethodTypeChecker >> hasErrors [
	
	^errors notEmpty
]

{ #category : #testing }
MethodTypeChecker >> hasErrorsOrWarnings [
	
	^errors notEmpty or: [ warnings notEmpty ]
]

{ #category : #testing }
MethodTypeChecker >> hasNoErrorsAndWarnings [
	
	^errors isEmpty and: [ warnings isEmpty ]
]

{ #category : #testing }
MethodTypeChecker >> hasProblems [
	
	^problems notEmpty 
]

{ #category : #initialization }
MethodTypeChecker >> initializeErrorsWarningsAndProblems [
	
	errors := OrderedCollection new.
	warnings := OrderedCollection new.
	problems := OrderedCollection new.
]

{ #category : #initialization }
MethodTypeChecker >> initializeFor: aMethod [ 
	
	method := aMethod asMethodReference 
]

{ #category : #method }
MethodTypeChecker >> method [
	
	^method
]

{ #category : #method }
MethodTypeChecker >> methodClass [
	
	^method methodClass 
]

{ #category : #method }
MethodTypeChecker >> methodReference [
	
	^method asMethodReference 
]

{ #category : #method }
MethodTypeChecker >> methodSelector [
	
	^method selector 
]

{ #category : #problems }
MethodTypeChecker >> problems [
	
	^problems
]

{ #category : #problems }
MethodTypeChecker >> problemsDetect: aCondition ifNone: noneBlock [

	^problems detect: aCondition ifNone: noneBlock 
]

{ #category : #problems }
MethodTypeChecker >> problemsSize [
	
	^problems size
]

{ #category : #'type cheking - value' }
MethodTypeChecker >> typeCheck [
	
	method isPrimitive ifTrue: [ ^self ].
	method isAnnotatingTypes
		ifTrue: [ self typeCheckWhenAnnotatingTypes ]
	 	ifFalse: [ self typeCheckWhenNotAnnotatingTypes ]
]

{ #category : #'type cheking - value' }
MethodTypeChecker >> typeCheckWhenAnnotatingTypes [
	
	(MethodTypeCheckerVisitor for: method collectingErrorsInto: errors warningsInto: warnings andProblemsInto: problems) value
	
]

{ #category : #'type cheking - value' }
MethodTypeChecker >> typeCheckWhenNotAnnotatingTypes [
	
	problems add: (MethodNotAnnotatingTypesProblem for: method)
]

{ #category : #'type checking' }
MethodTypeChecker >> value [

	self 
		initializeErrorsWarningsAndProblems;
		typeCheck.
			
	^self
]

{ #category : #warning }
MethodTypeChecker >> warnings [
	
	^warnings
]

{ #category : #warning }
MethodTypeChecker >> warningsDetect: aCondition ifNone: aNoneBlock [

	^warnings detect: aCondition ifNone: aNoneBlock 
]

{ #category : #warning }
MethodTypeChecker >> warningsIsEmpty [
	
	^warnings isEmpty 
]

{ #category : #warning }
MethodTypeChecker >> warningsSize [
	
	^warnings size
]
