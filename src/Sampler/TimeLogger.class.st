Class {
	#name : #TimeLogger,
	#superclass : #VMSampler,
	#category : #Sampler
}

{ #category : #accessing }
TimeLogger >> tallyProcess: aProcess sampledMethod: aMethod weight: tallyTicks gcTime: gcTime ticksToSample: ticksToSample [
	"Hook for subclasses"

	aProcess suspendedContext ifNil: [ ^ self ].
	Transcript
		show: 'suspended context: ';
		show: aProcess suspendedContext method displayString;
		cr;
		show: 'suspended method: ';
		show: aMethod displayString;
		cr;
		cr
]
