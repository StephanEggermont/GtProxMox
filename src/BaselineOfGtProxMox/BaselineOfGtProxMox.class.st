Class {
	#name : #BaselineOfGtProxMox,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtProxMox
}

{ #category : #loading }
BaselineOfGtProxMox class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'GtProxMox' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGtProxMox >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GtProxMox'
		]
]
