Class {
	#name : #ManyMethodsTypeCheckerTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-TypeChecking-Tests'
}

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test01ManyMethodsCanBeTypeChecked [

	| methodWithManyTypeErrorsTypeChecker methodWithTypeErrorTypeChecker typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithTypeError. TypeCheckerTestMethods >> #methodWithManyTypeErrors }.
	
	typeChecker value.
	
	methodWithTypeErrorTypeChecker := (TypeCheckerTestMethods >> #methodWithTypeError) typeCheck.
	methodWithManyTypeErrorsTypeChecker := (TypeCheckerTestMethods >> #methodWithManyTypeErrors) typeCheck.
	
	self assert: typeChecker errorsSize equals: methodWithTypeErrorTypeChecker errorsSize + methodWithManyTypeErrorsTypeChecker errorsSize.
	self assert: typeChecker warningsSize equals: methodWithTypeErrorTypeChecker warningsSize + methodWithManyTypeErrorsTypeChecker warningsSize.

]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test02ClassesCanBeTypeChecked [

	| typeChecker typeCheckers |
	
	typeChecker := MethodTypeCheckerTest typeCheck.
	
	typeChecker value.
	
	typeCheckers := MethodTypeCheckerTest selectors collect: [ :aSelector |  (MethodTypeCheckerTest >> aSelector) typeCheck].
	typeCheckers := typeCheckers, (MethodTypeCheckerTest class selectors collect: [ :aSelector | (MethodTypeCheckerTest >> aSelector) typeCheck ]).
	
	self assert: typeChecker errorsSize equals: (typeCheckers sum: [ :aTypeCheker | aTypeCheker errorsSize ]).
	self assert: typeChecker warningsSize equals: (typeCheckers sum: [ :aTypeCheker | aTypeCheker warningsSize ]).

]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test03MethodsWithoutTypeAnnotationsLogsAProblem [

	| typeChecker methodToCheck  |
	
	methodToCheck := TypeCheckerTestMethods >> #methodNotAnnotatingTypes.
	typeChecker := ManyMethodsTypeChecker forAll: { methodToCheck }.
	methodToCheck removeProperties.
	
	typeChecker value.
	
	self assert: 1 equals: typeChecker problemsSize.
	self assert: typeChecker errorsIsEmpty.
	self assert: typeChecker warningsIsEmpty.

]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test04ProblemsDetectIfNone [

	| typeCheckProblem typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithNoReturnTypes }.
	typeChecker := typeChecker value.
	
	self assert: 1 equals: typeChecker problemsSize.
	
	typeCheckProblem := typeChecker problemsDetect: [ :aTypeCheckProblem | true ] ifNone: [ self fail ].
	self assert: typeCheckProblem receiver isMessageNode.	
	self assert: #printString equals: typeCheckProblem selector key.

]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test05ProblemsDetectIfNoneValuesIfNoneWhenNoProblemFound [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithoutTypeErrors }.
	typeChecker value.
	
	typeChecker problemsDetect: [ :aTypeCheckProblem | true ] ifNone: [ ^self ].
	
	self fail
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test06WarningsCollectsAllTypeCheckersWarnings [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithWarningForError }.
	typeChecker value.
	
	self assert: typeChecker warnings notEmpty
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test07ErrorsDetectIfNone [

	| typeChecker error |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithManyTypeErrors }.
	typeChecker value.
	
	error := typeChecker errorsDetect: [ :anError | true ] ifNone: [ self fail ].
	self assert: #date equals: error selector key 
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test08ErrorsDetectIfNoneValuesIfNoneWhenNoProblemFound [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithoutTypeErrors }.
	typeChecker value.
	
	typeChecker errorsDetect: [ :aTypeCheckProblem | true ] ifNone: [ ^self ].
	
	self fail

	
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test09ProblemsCollectsTypeCheckersProblems [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithNoReturnTypes }.
	typeChecker := typeChecker value.
	
	self assert: typeChecker problems notEmpty

]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test10WarningsDetectIfNone [

	| typeChecker typeWarning |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithWarningForError. }.
	typeChecker value.
	
	typeWarning := typeChecker warningsDetect: [ :aTypeWarning | true ] ifNone: [ self fail ].
	self assert: typeWarning receiver isMessageNode.	
	self assert: #first equals: typeWarning selector key.

]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test11WarningsDetectIfNoneValuesIfNoneWhenNoProblemFound [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithoutTypeErrors }.
	typeChecker value.
	
	typeChecker warningsDetect: [ :aTypeCheckProblem | true ] ifNone: [ ^self ].
	
	self fail

	
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test12HasErrorsReturnsTrueIfATypeCheckerHasErrors [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithTypeError }.
	typeChecker value.
	
	self assert: typeChecker hasErrors 
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test13HasErrorsReturnsFalseWhenNoErrorFound [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithoutTypeErrors }.
	typeChecker value.
	
	self deny: typeChecker hasErrors 
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test14ErrorsCollectsAllTypeCheckersErrors [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithTypeError }.
	typeChecker value.
	
	self assert: typeChecker errors notEmpty 
]

{ #category : #tests }
ManyMethodsTypeCheckerTest >> test15HasErrorsOrWarnings [

	| typeChecker |
	
	typeChecker := ManyMethodsTypeChecker forAll: { TypeCheckerTestMethods >> #methodWithTypeError }.
	typeChecker value.
	
	self assert: typeChecker hasErrorsOrWarnings 
]
