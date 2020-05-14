Class {
	#name : #CustomerTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Playground'
}

{ #category : #'as yet unclassified' }
CustomerTest >> test01 [

	Customer named: 'Juan' with: 'Perez' bornOn: Date today.
	Customer named: 1 with: 2 bornOn: DateAndTime now.
]

{ #category : #'as yet unclassified' }
CustomerTest >> test02 [

	(TestCase allSubclasses select: [:aTestCase | aTestCase category = 'Chronology-Tests']) 
		do: [:aTestCase | aTestCase suite run ].
]

{ #category : #'as yet unclassified' }
CustomerTest >> test03 [

	(TestCase allSubclasses select: [:aTestCase | aTestCase category =  'Regex-Tests-Core']) 
		do: [:aTestCase | aTestCase suite run ].
]
