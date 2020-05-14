Class {
	#name : #PerfomanceTest,
	#superclass : #Object,
	#category : #'LiveTyping-Tests'
}

{ #category : #'as yet unclassified' }
PerfomanceTest class >> aconcaguaTime [

	"
	self aconcaguaTime
	"
	
	^ self timeToRunTestsOf: 'Aconcagua' 
]

{ #category : #'as yet unclassified' }
PerfomanceTest class >> chaltenTime [

	"
	self chaltenTime
	"
	
	^ self timeToRunTestsOf: 'Chalten'
]

{ #category : #'as yet unclassified' }
PerfomanceTest class >> kernelTestsTime [

	"
	self kernelTestsTime
	"
	
	^#('Tests-Exceptions' "'Tests-Kernel-Numbers'" "'Tests-Kernel'" 'Tests-Kernel-Chronology' 'Tests-Collections' "'Tests-System'" 'Tests-Kernel-Classes' 'Tests-Collections-Arrayed') 
		sum: [ :aCategory |  self timeToRunTestsOf: aCategory ].
	
]

{ #category : #'as yet unclassified' }
PerfomanceTest class >> refactoringTime [

	"
	self refactoringTime
	"
	
	^self timeToRunTestsOf: 'Refactoring'.
	
]

{ #category : #'as yet unclassified' }
PerfomanceTest class >> ticTacToeTime [

	"
	self ticTacToeTime
	"
	
	^ self timeToRunTestsOf: 'TicTacToe'
]

{ #category : #'as yet unclassified' }
PerfomanceTest class >> timeToRunTestsOf: aCategoryBeginName [

	| suite testCases |
	
	testCases := TestCase allSubclasses select: [:aTestCase | aTestCase category beginsWith: aCategoryBeginName ].
	suite := TestSuite forTestCaseClasses: testCases named: ' tests'.
	
	^[ suite run ] timeToRun.

]
