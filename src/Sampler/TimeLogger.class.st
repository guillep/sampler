Class {
	#name : 'TimeLogger',
	#superclass : 'VMSampler',
	#category : 'Sampler',
	#package : 'Sampler'
}

{ #category : 'accessing' }
TimeLogger >> tallyProcess: aProcess sampledMethod: aMethod weight: tallyTicks gcTime: gcTime ticksToSample: ticksToSample [
	"Hook for subclasses"

	self haltIf: [ tallyTicks < 0 ].
	Transcript
		show: 'suspended context: ';
		show: aProcess suspendedContext method displayString;
		cr;
		show: 'suspended method: ';
		show: aMethod displayString;
		cr;
		cr
]
