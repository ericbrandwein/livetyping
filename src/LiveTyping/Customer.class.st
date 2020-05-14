Class {
	#name : #Customer,
	#superclass : #Object,
	#instVars : [
		'firstName',
		'lastName',
		'dateOfBirth'
	],
	#category : #'LiveTyping-Playground'
}

{ #category : #'instance creation' }
Customer class >> named: aFirstName with: aLastName bornOn: aDateOfBirth [

	^self new initializeNamed: aFirstName with: aLastName bornOn: aDateOfBirth
	
]

{ #category : #initialization }
Customer >> initializeNamed: aFirstName with: aLastName bornOn: aDateOfBirth [
	
	firstName := aFirstName. 
	lastName := aLastName.
	dateOfBirth := aDateOfBirth
]

{ #category : #xx }
Customer >> m0 [

	1 yourself class.
	$a yourself 
]

{ #category : #xx }
Customer >> m0: p1 [

	| c |
"
self new m0: 1.
self new m0: 1.0
self new m0: String
"
	1 yourself class.
	$a class.
	
	p1 class class class class class. 
	c := p1 class.
	c class
]

{ #category : #qqq }
Customer >> m1 [
"self new m1"
	| t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 |
	 
	t1 := nil.
	t1 := 1.
	t1 := t1 + (1/3).
	t2 := 2.0.
	t3 := 3.
	t4 := 4.
	t5 := 5.
	t6 := 6.
	t7 := 7.
	t8 := 8.
	t9 := t2+t3+t4+t5+t6+t7+t8.
	t10 := 'hola'.
	t1 := 'x'.
	t9 := t9+1.
	^t10
]

{ #category : #xx }
Customer >> m11 [
"self new m11" 
	| q1 t2 t3 t4 t5 t6 t7 t8 t9 t10 |
	 
	q1 := nil.
	q1 := 1.
	q1 := q1 + (1/3).
	t2 := 2.0.
	t3 := 3.
	t4 := 4.
	t5 := 5.
	t6 := 6.
	t7 := 7.
	t8 := 8.
	t9 := t2+t3+t4+t5+t6+t7+t8.
	t10 := 'hola'.
	q1 := 'x'.
	t9 := t9+1.
	
	^t10
]

{ #category : #ppp }
Customer >> m2 [

	self m1.
	^nil
]

{ #category : #'apply primitives' }
Customer >> m3 [

	^true and: [ false ]
	
]

{ #category : #debugging }
Customer >> m4 [

	[ :a | a factorial ] value: 10.
	[ :a | a factorial ] value: 10.
]

{ #category : #ppp }
Customer >> m5 [

	[ ^10 factorial ] value
]

{ #category : #ppp }
Customer >> m6 [

	^false or: [ false ]
]

{ #category : #ppp }
Customer >> m7 [

	^self
]

{ #category : #comparing }
Customer >> m8 [

	^true
]

{ #category : #ppp }
Customer >> m8: a [

	^a
]

{ #category : #ppp }
Customer >> m8a [

	^true
]

{ #category : #ppp }
Customer >> metodoClosure: p1 [

	| t1 t2 |
	
	t2 := { 1. 2. 3. }.
	t1 := t2 at: 1.
	[ | qq | qq := 2 ] value.
	
	^t1 + p1
]
