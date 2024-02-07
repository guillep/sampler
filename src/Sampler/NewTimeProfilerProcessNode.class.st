Class {
	#name : 'NewTimeProfilerProcessNode',
	#superclass : 'NewTimeProfilerNode',
	#instVars : [
		'process'
	],
	#category : 'Sampler',
	#package : 'Sampler'
}

{ #category : 'visualisation' }
NewTimeProfilerProcessNode >> flamegraph [

	| builder colorPalette |
	builder := RSFlameGraph new.
	builder boxShape
		color: Color veryLightGray;
		cornerRadius: 2.
	builder
		graphWidth: 1000;
		modelWeight: [ :f | f totalWeight ];
		explore: self nesting: [ :e |
			e children select: [ :c |
					c hasChildren and: [ c totalWeight / self totalWeight > 0.015 ] ] ]
		leaves: [ :e |
			e children select: [ :c |
					c hasChildren not and: [ c totalWeight / self totalWeight > 0.015 ] ] ].
	builder build.

	colorPalette := NSScale linear
		                domain: {
				                0.
				                self maxWeight };
		                range: {
				                Color blue.
				                Color red };
		                yourself.

	"Add labels to rectangles, when they fit inside."
	builder shapes do: [ :shape |
		| location labelBuilder label |
		shape color: (colorPalette scale: shape model weight)
		"location := RSLocation new middle; inner; left; offset: 5@0; yourself.
		labelBuilder := RSMultilineLabelBuilder new
			wrapStrategy: (RSWrapEllipsisStrategy new wrapMaxWidth: shape width - 10);
			yourself.
		labelBuilder labelShape color: shape color contrastingBlackAndWhiteColor.
		label := labelBuilder shapeFor: shape model name.
		location stick: label on: shape.
		(label width > 25 and: [ (label width+5) < shape width ]) ifTrue: [
			builder canvas addShape: label ]" ].

	^ builder canvas
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'accessing' }
NewTimeProfilerProcessNode >> process: aProcess [ 
	
	process := aProcess
]
