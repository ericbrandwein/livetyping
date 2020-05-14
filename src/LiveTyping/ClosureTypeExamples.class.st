Class {
	#name : #ClosureTypeExamples,
	#superclass : #Object,
	#category : #'LiveTyping-Playground'
}

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> inject: thisValue into: binaryBlock [ 
	"Accumulate a running value associated with evaluating the argument, 
	binaryBlock, with the current value of the argument, thisValue, and the 
	receiver as block arguments. For instance, to sum the numeric elements 
	of a collection, aCollection inject: 0 into: [:subTotal :next | subTotal + 
	next]."

	| nextValue |
	nextValue _ thisValue.
	self do: [:each :v | nextValue _ binaryBlock value: nextValue value: each].
	^nextValue
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m1 [

	| t1 t2 |
	
	t1 := 1.
	t2 := 5.
	
	^[ |c1t0| 
		c1t0 := 20.
		t1 := t1 + t2 + c1t0 ].
	
	
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m10 [
   | t1 |

   t1 := 0.   "<-- it will save SmallInteger in (method additionalState contextTypesAt: 1) at: 2."
   [ | t2 | t2 := 'hello' ] value. "<-- it will save String in (method additionalState contextTypesAt: 2) at: 1"

   [ | t3 | t3 := 3.14 ] value. "<-- it will save Float in (method additionalState contextTypesAt: 3) at: 1"
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m1: p1 [
   | t1 |

   t1 := 0.   "<-- it will save SmallInteger in (method additionalState contextTypesAt: 1) at: 2."
   [ | t2 | t2 := 'hello' ] value. "<-- it will save String in (method additionalState contextTypesAt: 2) at: 1"

   [ | t3 | t3 := 3.14 ] value. "<-- it will save Float in (method additionalState contextTypesAt: 3) at: 1"
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m1_read_temp [

	| t1 |
	
	t1 := 1.
	[t1 + 1 ] value.
	
	^t1
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m1_read_write_temp [

	| t1 |
	
	t1 := 1.
	[ t1 := t1 + 1 ] value.
	
	^t1
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m1_temps_not_in_block_read_temp [

	| n1 n2 t1 |
	
	t1 := 1.
	[t1 + 1 ] value.
	
	n1 := n2 := 'hola'.
	n1 size + n2 size.
	
	^t1
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m1_temps_not_in_block_read_write_temp [

	| n1 n2 t1 |
	
	t1 := 1.
	[t1 := t1 + 1 ] value.
	
	n1 := n2 := 2.
	n1 := n1 + n2.

	^t1
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m1_write_temp_outside_block [

	| t1 |
	
	t1 := 1.
	[ t1 + 1 ] value.
	
	t1 := 2.
	
	^t1
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m2 [

	| t1 t2 |
	
	[ t1 := 1. t1 + 1.
	t2 := 2 ].

]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m2_block_with_arguments [

	"
	self new m2_block_with_arguments
	"
	| n1 n2 t1 |
	
	t1 := 1.
	[ :a | t1 := t1 + a ] value: 1.
	
	n1 := n2 := 2.
	n1 := n1 + n2.

	^t1
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m3 [
"
self new m3
"
	| a1 t1 t2 |
	
	t1 := 1.
	
	a1  := [  |t3| 
	t3 := 'hola'.
	t1 := 1. t1 + 1.
	t2 := 2 ].

	a1 value.

]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m4_many_temps_in_remote_vector [

	| t1 t2 t3 |
	
	[ t1 := 1 ] value.
	[ t2 := 'hello' ] value.
	
	t3 := t1 + t2 size.
	
	^t3
]

{ #category : #'as yet unclassified' }
ClosureTypeExamples >> m5_many_temps_in_remote_vector_with_block_params_and_temps [

	| t1 t2 t3 |
	
	t3 := 11.
	
	[ :p1 :p2 | | b1t1 b1t2 | 
		t1 := 1.
		b1t1 := 10.
		b1t2 := b1t1 + 1 ] value: 1 value: 2.
	
	[ :p1 | |b2t1 | 
		t2 := 'hello'.
		b2t1 := 20 ] value: 3.
	
	t3 := t1 + t2 size.
	
	^t3
]
