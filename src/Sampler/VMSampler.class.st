Class {
	#name : 'VMSampler',
	#superclass : 'Object',
	#instVars : [
		'ticksPerTally',
		'profilerSemaphore',
		'profilerProcess'
	],
	#category : 'Sampler',
	#package : 'Sampler'
}

{ #category : 'as yet unclassified' }
VMSampler >> highResClock [
	"Primitive. Answer the value of the high resolution clock if this computer has one.
	Usually, this should be the highest resolution value available, for example on Intel
	it will be the value of the time stamp counter register."

	<primitive: 'primitiveHighResClock'>
	^ 0
]

{ #category : 'as yet unclassified' }
VMSampler >> initialize [

	super initialize.
	profilerSemaphore := Semaphore new.
	ticksPerTally := 200
]

{ #category : 'as yet unclassified' }
VMSampler >> profile: aBlock [

	self startProfiling.
	aBlock ensure: [ self stopProfiling ]
]

{ #category : 'as yet unclassified' }
VMSampler >> profileSemaphore: aSemaphore [
	"Primitive. Install the semaphore to be used for profiling,
	or nil if no semaphore should be used.
	See also primitiveProfileStart."

	<primitive: 'primitiveProfileSemaphore'>
	^ self primitiveFailed
]

{ #category : 'as yet unclassified' }
VMSampler >> profileStart: counter [
	"Primitive. Begin profiling execution every by using the interrupt check-counter instead of a time-based process (which is limited to timing resolution and triggers off the same signal that many of the processes being profiled trigger off leading to consistently wrong results).
	The argument is the number of interrupt checks (method activations) to let go by before taking a sample. The sample is being stored in the profileSample iVar which can be retrieved by executing primitiveProfileSample. When a sample is taken, it signals the semaphore specified in primitiveProfileSemaphore.
	If the argument is less or equal to zero, it disables profiling."

	<primitive: 'primitiveProfileStart'>
	^ self primitiveFailed
]

{ #category : 'as yet unclassified' }
VMSampler >> startProfiling [

	profilerProcess := [ 
		Transcript show: 'start profiling!'; cr.
		self profileSemaphore: profilerSemaphore.
		[ true] whileTrue: [ self tally ]
	] forkAt: Processor timingPriority - 1
]

{ #category : 'as yet unclassified' }
VMSampler >> stopProfiling [

	Transcript show: 'stop profiling!'; cr.
	profilerProcess suspend.
	profilerProcess := nil.
	self profileStart: 0.
	self profileSemaphore: nil.


]

{ #category : 'accessing' }
VMSampler >> tally [

	| tallyStart gcTimeStart gcTime tallyTicks talliedProcess |
	gcTimeStart := Smalltalk vm totalGCTime.
	tallyStart := self highResClock.

	self profileStart: ticksPerTally.
	profilerSemaphore wait.

	gcTime := 0"(Smalltalk vm totalGCTime - gcTimeStart) * 1000000.".
	tallyTicks := self highResClock - tallyStart" - gcTime".

	"It may happen due to the frequency of sampling, that two or more samples are taken together before we are able to consume them.
	In that case, the second sample will override the first sample.
	The primitive will return only one of them and return nil in subsequent calls until there is a new sample"
	talliedProcess := Smalltalk profileSample.
	talliedProcess ifNil: [ ^ self ].

	self
		tallyProcess: talliedProcess
		sampledMethod: Smalltalk profilePrimitive
		weight: tallyTicks
		gcTime: gcTime
		ticksToSample: ticksPerTally
]

{ #category : 'accessing' }
VMSampler >> tallyProcess: aProcess sampledMethod: aMethod weight: tallyTicks gcTime: gcTime ticksToSample: ticksToSample [
	"Hook for subclasses"

	
]
