Class {
	#name : #TypeCheckingResultSet,
	#superclass : #Object,
	#instVars : [
		'methodTypeChecker',
		'showProblems'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
TypeCheckingResultSet class >> for: aMethodTypeChecker showingProblems: showingProblems [ 
	
	^self new initializeFor: aMethodTypeChecker showingProblems: showingProblems 

]

{ #category : #list }
TypeCheckingResultSet >> calculateList [

	messageList := methodTypeChecker errorsAndWarningsAsMethodReferencesWithProblems: showProblems.
	self reformulateList.
	
]

{ #category : #accessing }
TypeCheckingResultSet >> contents: aString notifying: aRequestor [ 

	| result |

	result := super contents: aString notifying: aRequestor.
	methodTypeChecker := methodTypeChecker value.
	self calculateList.
	
	^result 

]

{ #category : #initialization }
TypeCheckingResultSet >> initializeFor: aMethodTypeChecker showingProblems: showingProblems [ 
	
	methodTypeChecker := aMethodTypeChecker.
	showProblems := showingProblems.
	self calculateList.
	
	"It does not matter the methodSelector, it is just a symbol that flags that ranges should be look for selecting - Hernan"
	self autoSelectString: methodTypeChecker methodSelector 
]

{ #category : #'source code ranges' }
TypeCheckingResultSet >> messageSendsRangesOf: aSelector [

	^ selectedMessage 
		ifNil: [ #() ]
		ifNotNil: [ selectedMessage sourceCodeRange ]

]
