Class {
	#name : #NewTimeProfiler,
	#superclass : #VMSampler,
	#instVars : [
		'roots'
	],
	#category : 'Sampler'
}

{ #category : #'as yet unclassified' }
NewTimeProfiler >> initialize [

	super initialize.
	roots := Dictionary new
]

{ #category : #'as yet unclassified' }
NewTimeProfiler >> rootNodeForProcess: aProcess [

	^ roots
		at: aProcess
		ifAbsentPut: [ NewTimeProfilerProcessNode new process: aProcess ]
]

{ #category : #'as yet unclassified' }
NewTimeProfiler >> tallyProcess: aProcess sampledMethod: aMethod weight: tallyTicks gcTime: gcTime ticksToSample: ticksToSample [
	"aContext representing a stack, we must add the weight to the nodes all over the tree"

	| currentNode |
	gcTime > 0 ifTrue: [
		(self rootNodeForProcess: #gc) addWeight: gcTime ].

	aProcess suspendedContext ifNil: [ ^ self ].
	currentNode := self rootNodeForProcess: aProcess.
	aProcess suspendedContext stack reverseDo: [ :context |
		currentNode := currentNode childForMethod: context method ].
	
	"If we have a primitive method here, time is ambiguous as we don't know how much time we spent on the primitive. We can add some heuristics, as we know probably most of the time was spent on the primitive."
	aMethod ifNotNil: [
		"Ambiguity: add time to parent"
		currentNode parent addWeight: tallyTicks.
		currentNode parent childForMethod: aMethod.
		^ self
	].
	"Else, attribute the entire time to the leaf method in the stack"
	currentNode addWeight: ticksToSample
]
