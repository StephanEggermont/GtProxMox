Class {
	#name : #PveCluster,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client',
		'api'
	],
	#category : #'GtProxMox-Model'
}

{ #category : #'as yet unclassified' }
PveCluster class >> connectFrom: aFileName [
	|api|
	api := PveApi connectFrom: aFileName.
	^self new
		api: api;
		get
]

{ #category : #'as yet unclassified' }
PveCluster >> api [
	^api
]

{ #category : #accessing }
PveCluster >> api: anApi [
	api := anApi 
]

{ #category : #'as yet unclassified' }
PveCluster >> colorForVm: aVm [
	^aVm status = 'running' ifTrue: [Color green alpha: 0.3]
	ifFalse: [Color red alpha: 0.3]
]

{ #category : #accessing }
PveCluster >> get [
	self rawData: (api get: 'cluster/resources')
]

{ #category : #'as yet unclassified' }
PveCluster >> gtNodesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Nodes';
		priority: 20;
		items: [ self nodes ];
		column: 'Name' text: [ :node | node name ];
		column: 'Status' text: [ :node | node status ];
		column: 'CPU Usage' text: [ :node | 
			node cpuUsage ifNotNil: [ :usage | 
				(usage * 100) rounded asString, '%' ] ifNil: [ 'N/A' ] ];
		column: 'Memory Usage' text: [ :node | 
			node memoryUsagePercent ifNotNil: [ :usage |
				usage rounded asString, '%' ] ifNil: [ 'N/A' ] ];
		actionUpdateButton
]

{ #category : #'as yet unclassified' }
PveCluster >> gtOverviewFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Overview';
		priority: 10;
		text: [ 
			String streamContents: [ :s |
				s nextPutAll: 'Proxmox Cluster Overview'; cr; cr.
"				s nextPutAll: 'Nodes: ', self nodes size asString; cr.
				self nodes do: [ :node |
					s nextPutAll: '  • ', node name, ' (', node status, ')'; cr ].
				s cr.
"				s nextPutAll: 'Total VMs: ', self totalVMs asString; cr.
				s nextPutAll: 'Running VMs: ', self runningVMs asString; cr ] ]
]

{ #category : #'as yet unclassified' }
PveCluster >> gtResourcesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Resources Map';
		priority: 30;
		painting: [ :mondrian | 
			| nodes |
			nodes := self nodes.
			mondrian nodes 
		shape: [ :each | GtMondrianUMLClassElement withDefaultContainer 
			label: (each name) asString ];
		with: nodes;
		forEach: [:node |
			mondrian nodes
				shape: [ :me | BlElement new 
				background: (self colorForVm: me);
				border: (BlBorder paint: Color gray);
				size: (10 @10);
				yourself  ];
			with: (node vms) ]in: #default.
		mondrian layout grid ]
]

{ #category : #'as yet unclassified' }
PveCluster >> nodes [
	"Get all nodes in the cluster"
	^ self rawData select: [ :item | (item at: 'type') = 'node' ]
		thenCollect: [ :nodeData | 
			PveNode new 
				rawData: nodeData; 
				cluster: self;
				api: self api;
				yourself ]
]

{ #category : #'as yet unclassified' }
PveCluster >> rawData [
	^rawData
]

{ #category : #accessing }
PveCluster >> rawData: data [ 
	rawData := data
]

{ #category : #'as yet unclassified' }
PveCluster >> runningVMs [  
	^ self nodes sum: [ :node | 
		node vms count: [ :vm | vm status = 'running' ] ]
]

{ #category : #'as yet unclassified' }
PveCluster >> totalVMs [
	^ self nodes sum: [ :node | node vms size ]
]
