Class {
	#name : #NewTimeProfilerNode,
	#superclass : #Object,
	#instVars : [
		'method',
		'children',
		'weight',
		'totalWeight',
		'parent'
	],
	#category : 'Sampler'
}

{ #category : #'instance creation' }
NewTimeProfilerNode class >> newForMethod: aMethod [

	^ self new
		  method: aMethod;
		  yourself
]

{ #category : #adding }
NewTimeProfilerNode >> addWeight: anInteger [ 
	
	weight := weight + anInteger
]

{ #category : #accessing }
NewTimeProfilerNode >> childForMethod: aMethod [

	^ children at: aMethod ifAbsentPut: [
		  (NewTimeProfilerNode newForMethod: aMethod)
			  parent: self;
			  yourself ]
]

{ #category : #accessing }
NewTimeProfilerNode >> children [
	^ children values
]

{ #category : #testing }
NewTimeProfilerNode >> hasChildren [
	
	^ children notEmpty
]

{ #category : #accessing }
NewTimeProfilerNode >> initialize [

	super initialize.
	weight := 0.
	children := OrderedDictionary new
]

{ #category : #'as yet unclassified' }
NewTimeProfilerNode >> inspectionMethod: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Method'> 
	
	^ method inspectionSource
]

{ #category : #accessing }
NewTimeProfilerNode >> maxWeight [

	self children ifEmpty: [ ^ weight ].
	^ weight max: (self children max: [ :e | e maxWeight ])
]

{ #category : #accessing }
NewTimeProfilerNode >> method [
	^ method
]

{ #category : #accessing }
NewTimeProfilerNode >> method: aMethod [

	method := aMethod
]

{ #category : #accessing }
NewTimeProfilerNode >> name [
	
	^ method displayString lines first
]

{ #category : #accessing }
NewTimeProfilerNode >> parent [
	
	^ parent
]

{ #category : #accessing }
NewTimeProfilerNode >> parent: aNewTimeProfilerNode [ 
	parent := aNewTimeProfilerNode
]

{ #category : #tallying }
NewTimeProfilerNode >> tally: aContext weight: anInteger [ 
	self shouldBeImplemented.
]

{ #category : #accessing }
NewTimeProfilerNode >> totalWeight [
	
	totalWeight ifNotNil: [ ^ totalWeight ].
	^ totalWeight := weight + (self children sum: #totalWeight)
]

{ #category : #accessing }
NewTimeProfilerNode >> weight [
	^ weight
]
